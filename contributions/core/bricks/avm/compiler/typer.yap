%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2013  Simon Petitjean

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

:-module(xmg_brick_avm_typer).

:-edcg:using([xmg_brick_mg_typer:types]).

xmg:stmt_type(iface,avm).

xmg:type_expr(avm:avm(Coord,Feats),Type):--
	!.
	
xmg:type_stmt(avm:avm(Coord,Feats),Type):--
	xmg:type_expr(avm:avm(Coord,Feats),Type),!.

xmg:type_expr(avm:dot(value:var(token(_,id(AVM))),token(_,id(Feat))),Type):--
	types::tget(AVM,CAVM),
	xmg_brick_avm_avm:dot(CAVM,Feat,Type),
	!.
