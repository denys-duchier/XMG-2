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


:-module(xmg_brick_syn_loader).

:-	use_module('xmg/brick/syn/compiler/edcg').

:-	use_module('xmg/brick/syn/compiler/compiler').
:-	use_module('xmg/brick/syn/compiler/typer').
:-	use_module('xmg/brick/syn/compiler/unfolder').
:-	use_module('xmg/brick/syn/compiler/generator').

:-	use_module('xmg/brick/syn/engine').
:-	use_module('xmg/brick/syn/most').
:-	use_module('xmg/brick/syn/nodename').

:-	use_module('xmg/brick/syn/compiler/convert').



