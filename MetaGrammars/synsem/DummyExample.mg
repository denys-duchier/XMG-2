type COLOR = {red,black,white}
property color : COLOR
%% use color with () dims (syn) %args (COLOR)

type CAT = {v,n,s,cl}
%%type CAT = {t}

type AGR = {m,f}
type NUM = {s,p}


%%feature cat : CAT

%type node_feats = [|cat:CAT]
%type node_props = [color:COLOR]

%%use syn:node with () dims (syn) args (node_props, node_feats)
%% use syn:node with (node_props, node_feats) dims (syn) 


class dummier
%%import dummy[]
declare ?T ?C ?A
{
	?C=dummy[];
	<syn>{
		node ?T (color=black) %[cat=whatever]
		}*=[arg2=?A]
		;
	?T=?C.X
}

class dummy
export X Y Z 
declare ?X ?Y ?Z ?T ?L ?C
{
  % <syn>{
  % 	node ?X (color=black) [cat=@{s,n}];
  % 	node ?Y (color=black) [cat=n];
  % 	node ?Z (color=black) [cat=v];
  % 	?X -> ?Y;
  % 	?X -> ?Z;
  % 	?Y >> ?Z
  % }
  % |
  {<syn>{
	node ?X (color=black) [cat=s, extracted= +]{ ...+
	     node ?Y (color=black) [cat=@{n,cl}]
	     ,,, 
	     node ?Z (color=black) [cat=?C, agr=[gen=m,num=s]]{
	     	  node ?T (color=black) [cat=?L]
		  }
	     
	     	} 
	}
	% ;
	% dummier[]
 }
 ;
 <iface>{ 
 		[cat=v,arg1=?L]
 }
}



value dummy
value dummier