\d .log

/ config settings
cfg.LEVELS:`error`warn`info`debug`trace
cfg.LEVEL:cfg.LEVELS?`info
cfg.FORMAT:`logfmt
cfg.FIELDS:()!()
now:{.z.p}
stdout:-1

render.plain:{[d] " "sv get @[d;`msg;.j.s]}
render.logfmt:{[d] " "sv "="sv'flip(string key d;get @[d;`msg;.j.s])}
render.json:.j.j

format:{[fmt] if[not fmt in key render;bad_format];cfg.FORMAT:fmt}
level:{[lvl] cfg.LEVEL:cfg.LEVELS?lvl}
fields:{[d] cfg[`FIELDS]:d}

print:{[lvl;msg]
 if[cfg.LEVEL<cfg.LEVELS?lvl;:()];
 op:msg;d:();
 if[not type[msg]in -10 10h;
  if[99<>type last msg;:"second arg must be a fields dict when passing a non-string arg"];
  op:first msg;
  d:last msg];
 fields:`ts`lvl`msg!(string now`;string lvl;op);
 fields,:cfg.FIELDS,d;
 stdout render[cfg.FORMAT]fields;
 }

info:print`info
warn:print`warn
error:print`error
debug:print`debug
trace:print`trace


\d .
.log.info"testing"
.log.fields`pid`test!(string .z.i;"some arg")
.log.warn"testing again"
.log.warn("next test";`arg5`ts!("yes";string .z.d))
.log.format`json
.log.error("next test";`arg5`ts!("yes";string .z.d))
.log.format`plain
.log.error("next test";`arg5`ts!("yes";string .z.d))
