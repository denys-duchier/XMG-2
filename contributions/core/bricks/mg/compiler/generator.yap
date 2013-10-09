%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2012  Simon Petitjean

%%  This program is free software: you can redistribute it and/or modify
%%  it under the terms of the GNU General Public License as published by
%%  the Free Software Foundation, either version 3 of the License, or
%%  (at your option) any later version.

%%  This program is distributed in the hope that it will be useful,
%%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%  GNU General Public License for more details.

%%  You should have received a copy of the GNU General Public License
%%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%% ========================================================================

:-module(xmg_brick_mg_generator).

:-edcg:thread(decls,edcg:table).
:-edcg:thread(name,edcg:counter).

:-edcg:weave([decls,name], [var_or_const/2,new_name/2, put_in_table/1, generate_class/2, import_calls/3,  unify_exports/4, list_exports/3, get_params/3, xmg_generator_control:generate/4]).

%% :- edcg:thread(xmg_generator:skolem, edcg:counter).
%% :- edcg:weave([xmg_generator:skolem],[xmg_generator:init_skolems/1]).

new_name(Name,Prefix):--
	name::incr,
	name::get(Get),
	atomic_concat([Prefix,Get],Name),!.

threads_([]):- !.
%% threads_([skolem-_|T]):-
%% 	threads_(T),!.
threads_([Dim-_|T]):-
	edcg:edcg_thread(xmg_generator:Dim, edcg:queue),
	threads_(T),!.

prefix_for_weave([],[]):- !.
prefix_for_weave([Dim-_|T],[xmg_generator:Dim|T1]):-
	prefix_for_weave(T,T1),!.


generate('MetaGrammar'(_,Classes,Values)):-
	xmg_dimensions:dims(Dims),
	threads_(Dims),
	xmg_table:table_new(TableIn),
	xmg_compiler:send_nl(info),
	xmg_compiler:send(info,' threading classes'),
	thread_classes(Classes),
	xmg_compiler:send(info,' generating classes'),
	generate_classes(Classes),
	generate_values(Values).



thread_classes([]):- !.
thread_classes([class(id(Class),_,_)|T]):-
	%% this part should be done before (for calls to classes that occur after)
	xmg_dimensions:dims(Dims),
	prefix_for_weave(Dims,PDims),	
	edcg:edcg_weave(PDims,[xmg_generator:Class/2]),!,

	thread_classes(T).
thread_classes([H|T]):-
	thread_classes(T).


generate_classes([]):-- !.
generate_classes([mutex(id(M,_))|T]):--
	asserta(xmg_compiler:mutex(M)),
	generate_classes(T),!.
generate_classes([mutex_add(id(M,_),id(A,_))|T]):--
	asserta(xmg_compiler:mutex_add(M,A)),
	generate_classes(T),!.
generate_classes([semantics|T]):--
	generate_classes(T),!.
generate_classes([class(id(Class),class(P,I,_,_,Stmt),coord(_,_,_))|T]):--

	xmg_compiler:send_nl(info),
	xmg_compiler:send(info,'______________________________________________'),
	xmg_compiler:send_nl(info),xmg_compiler:send_nl(info),
	xmg_compiler:send(info,'generating '),
	xmg_compiler:send(info,Class),xmg_compiler:send_nl(info),
	%xmg_compiler:send(info,Stmt),xmg_compiler:send_nl(info),

	xmg_exporter:declared(Class,List),

	xmg_table:table_new(TableIn),
	put_in_table(List) with (decls(TableIn,TableOut),name(_,_)),

	generate_class(class(id(Class),class(P,I,_,_,Stmt),coord(_,_,_)),List) with (decls(TableOut,_),name(0,_)),!,
	generate_classes(T).

generate_class(class(id(Class),class(P,I,_,_,Stmt),coord(_,_,_)),List):--
	
	%xmg_exporter:declared(Class,List),
	xmg_exporter:exports(Class,Exports),
	list_exports(Exports,List,LExports),

	import_calls(I,List,ICalls),

	get_params(P,List,GP),

	
	xmg_generator_control:generate(Stmt,List,Class,Generated),% with (decls(TableOut,_),name(0,_)),,
	Head=..[Class,params(GP),exports(LExports)],
	IGenerated=..[',',ICalls,Generated],

	%% add Class to Trace
	Put=..[put,Class],
	Trace=..['::',xmg_generator:trace,Put],
	Gen=..[',',Trace,IGenerated],

	%% Skolems=xmg_generator:init_skolems(List),
	%% xmg_compiler:send(info,List),
	%% SGen=..[',',Skolems,Gen],

	edcg:edcg_clause(xmg_generator:Head, Gen, Clause),
	asserta(xmg_generator:Clause),
	xmg_compiler:send(info,'generated '),
	xmg_compiler:send(info,Class),xmg_compiler:send_nl(info),
	%%xmg_compiler:send(info,Clause),
	!.

generate_values([]).
generate_values(['Value'(Value)|T]):-
	%% Value part
	xmg_dimensions:dims(Dims),
	callDims(Dims,CDims),
	Head=..[compute,Value,dims(Dims)],
	Call=..[Value,params(_),exports(_)|CDims],
	Compute=..[':-',Head,Call],
	asserta(Compute),
	generate_values(T).

import_calls([],_,true):--!.
import_calls([import(id(Class,C),AS)|T],List,ICalls):--
	xmg_exporter:exports(Class,E),
	unify_exports(E,List,AS,Exports),
	Call=..[Class,params(_),exports(Exports)],
	ICall=..[':',xmg_generator,Call],
	%% add Call to Trace
	%%Put=..[put,Class],
	%%Trace=..['::',xmg_generator:trace,Put],
	Gen=ICall,
	import_calls(T,List,T1),
	ICalls=..[',',Gen,T1],!.

unify_exports([],_,_,[]):-- !.
unify_exports([id(ID,C)-_|T],List,AS,[ID-V|T1]):--
	lists:member(id(ID,_)-id(IDA,_),AS),!,
	lists:member(id(IDA,_)-V,List),
	unify_exports(T,List,AS,T1),!.
unify_exports([id(ID,C)-_|T],List,AS,[ID-V|T1]):--
	decls::tget(ID,V),
	%%lists:member(id(ID,_)-V,List),
	unify_exports(T,List,AS,T1),!.

list_exports([],_,[]):-- !.
list_exports([id(ID,C)-_|T],List,[ID-V|T1]):--
	decls::tget(ID,V),
	%lists:member(id(ID,_)-V,List),
	list_exports(T,List,T1),!.

get_params([],_,[]):-- !.
get_params([id(ID,_)|T],List,[Var|T1]):--
	decls::tget(ID,Var),
	%lists:member(id(ID,_)-Var,List),
	get_params(T,List,T1),!.

callDims([],[]):-!.
callDims([iface-IFace|T],[[IFace]-[I],[I]-[I]|T1]):-
	callDims(T,T1),!.
callDims([Dim-CDim|T],[_-CDim,[]-[]|T1]):-
	callDims(T,T1),!.


var_or_const(Var,NVar):--
	var(Var),!,
	new_name(Name,'xmgvar'),
	Var=id(Name,no_coord),
	decls::tput(Name,NVar),!.
var_or_const(id(A,C),Var):--
	decls::tget(A,Var),!.
var_or_const(id(A,C),const(A,T)):--
	xmg_typer:type(T,TD),
	lists:member(id(A,_),TD),
	!.
var_or_const(id(A,C),feat(A)):--
	xmg_typer:feat(A,_),!.
var_or_const(id(A,C),field(A)):--
	xmg_typer:field(A,_),!.


var_or_const(id(A,C),var(B)):--
	throw(xmg(generator_error(variable_not_declared(A,C)))),!.
var_or_const(id(A,C),const(A,unknown)):--
	throw(xmg(generator_error(unknown_constant(A,C)))),!.
var_or_const(id(A,C),const(A,unknown)):--
	throw(xmg(generator_error(unknown_identifier(A,C)))),!.

var_or_const(string(A,C),const(A,string)):-- !.
var_or_const(int(A,C),const(A,int)):-- !.
var_or_const(bool(A,C),const(A,bool)):-- !.

put_in_table([]):-- !.
put_in_table([id(A,_)-B|T]):--
	decls::tput(A,B),
	put_in_table(T),!.
put_in_table([const(A,_)-const(N,_)|T]):--
	%% skolemize ?
	decls::tput(A,sconst(N,_)),
	put_in_table(T),!.

%% init_skolems([]):-- !.
%% init_skolems([_-H|T]):--
%% 	var(H),!,
%% 	init_skolems(T),!.
%% init_skolems([_-const(H,_)|T]):--
%% 	var(H),!,
%% 	skolem::incr,
%% 	skolem::get(H),
%% 	init_skolems(T),!.
%% init_skolems([_|T]):--
%% 	init_skolems(T),!.