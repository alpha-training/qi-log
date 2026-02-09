\d .log

now:{.z.p}
stdout:-1
LEVEL:.conf.LOGLEVELS?.conf.LOGLEVEL
FIELDS:()!()

/ configuration functions
setformat:{[fmt] if[not fmt in key render;bad_format];.conf.LOGFORMAT:fmt}
setlevel:{[lvl] LEVEL::.conf.LOGLEVELS?lvl}
usefields:{[d] FIELDS::@[d;where 100>type each d;.qi.tostr]}

/ internal functions
seval:{[f] $[(t:type r:f@(::))in -10 10h;r;t<0;string r;-3!r]}
render.plain:" "sv get@
render.logfmt:{" "sv "="sv'flip(string key x;get @[x;`msg;.j.s])}
render.json:.j.j

print:{[lvl;x]
 if[LEVEL<.conf.LOGLEVELS?lvl;:()];d:();
 if[not type msg:x;
  if[(0<count d)&99<>type d:last msg;'"second arg must be a fields dict when passing a non-string arg"];
  msg:first x];
 fields:`ts`lvl`h!(string now`;string lvl;string .z.w);
 fields:fields,FIELDS,$[count d;d;()],enlist[`msg]!enlist msg;
 fields:@[fields;where 100<=type each fields;seval];
 stdout render[.conf.LOGFORMAT]fields;
 }

{.log[x]:print x}each .conf.LOGLEVELS;

/

usage
.log.info"testing"
.log.setformat`logfmt
.log.usefields`pid`user`heap!(.z.i;{.z.u};{.Q.w[]`heap})
.log.warn"testing again"
.log.info("next test";`arg5`ts!("yes";string .z.d))
.log.setformat`json
.log.now:{.z.P}
.log.setformat`plain