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


:-module(xmg_brick_polAvm_loader).

:-use_module('xmg/brick/avm/compiler/loader').
:-use_module('xmg/brick/polAvm/compiler/typer').
:-use_module('xmg/brick/polAvm/compiler/unfolder').
:-use_module('xmg/brick/polAvm/compiler/generator').
:-use_module('xmg/brick/polAvm/compiler/convert').

:-use_module('xmg/brick/polAvm/polarity').

