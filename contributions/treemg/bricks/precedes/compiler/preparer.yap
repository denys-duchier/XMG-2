%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2017  Denys Duchier

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

%% use precedes with (p1=v1, p2=v2) dims (d)
%% if there is a node X with p1=v1 and a node Y with p2=v2, X must precede Y

:- module(xmg_brick_precedes_preparer, []).

:-edcg:using(xmg_brick_mg_preparer:preparer).
:-edcg:weave([preparer],[prepare/2]).


get_instances(I):-
    xmg:precedes(I).

prepare(I,Out):--
	preparer::tget(nodes,Nodes),
        prepare_list(Nodes,I,Out,NNodes),
        preparer::tput(nodes,NNodes),!.

prepare_list([],(_,_),[],[]) :- !.
prepare_list([Node|Nodes], (feat(F1,V1,_),feat(F2,V2,_)), [(B1,B2)|T1],[Node|Nodes1]) :-
    Node=node(Prop,Feat,_), !,
    xmg_brick_avm_avm:avm(Prop, PL),
    xmg_brick_avm_avm:avm(Feat, FL),
    ( ( lists:member(F1-V1, PL) ; lists:member(F1-V1, FL) )
      -> B1=true ; B1=false ),
    ( ( lists:member(F2-V2, PL) ; lists:member(F2-V2, FL) )
      -> B2=true ; B2=false ),
    prepare_list(Nodes,(feat(F1,V1,_),feat(F2,V2,_)),T1,Nodes1),
    !.
prepare_list([Node|Nodes], (feat(F1,V1,_),feat(F2,V2,_)), T1, [Node|Nodes1]) :-
    not(Node=node(Prop,Feat,_)),!,
    prepare_instance(Nodes,(feat(F1,V1,_),feat(F2,V2,_)),T1, Nodes1),
    !.

%% %% prepare/3 is for preparing 1 instance of the principle

%% prepare(Node, (feat(F1,V1,_),feat(F2,V2,_)), (B1,B2)) :-
%%     Node=node(Prop,Feat,_),
%%     xmg_brick_avm_avm:avm(Prop, PL),
%%     xmg_brick_avm_avm:avm(Feat, FL),
%%     ( ( lists:member(F1V1, PL) ; lists:member(F1V1, FL) )
%%       -> B1=true ; B1=false ),
%%     ( ( lists:member(F2V2, PL) ; lists:member(F2V2, FL) )
%%       -> B2=true ; B2=false ),!.
