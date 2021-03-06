%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2016  Simon Petitjean

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

:- module(xmg_brick_lemma_convert).

:- xmg:edcg.


xmg:xml_convert_term(lemma:solved(Lemma), elem(lemma, features([name-Entry, cat-CAT]),children(Feats))) :--
	lists:member(feat(entry,string(SEntry)),Lemma),
        atom_codes(Entry,SEntry),
        lists:member(feat(cat,CAT),Lemma),
	xmg:send(info,Lemma),
	xmg:xml_convert_term(lemma:feats(Lemma),Feats),
	!.

xmg:xml_convert_term(lemma:feats(Lemma),Feats):--
	feat_tree(Lemma,Tree),
        %% What to do with the gloss? Doesn't it belong to morph?
	Feats=[Tree],
	!.

feat_tree(Lemma,Tree):-
    	lists:member(feat(fam,Fam),Lemma),
	atom_concat(['family[@name=',Fam,']'],FamFeat),
	%% ToDo: Filters
	Tree=elem(anchor, features([tree_id-FamFeat]),children([elem(filter,children([elem(fs)]))])),!.

