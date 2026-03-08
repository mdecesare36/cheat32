#set page("a4", flipped: true, columns: 3, margin: 0.5cm)
#set columns(gutter: 0.25cm)
#set text(font: "Noto Sans", size: 10pt)
#set par(leading: 0.15cm, spacing: 0.2cm)

#let module(body) = {
    set text(weight: "bold", fill: blue)
    [#body --- ]
}

#let keyword(body) = {
    set text(style: "italic", fill: fuchsia)
    [#body]
}
#let num = [n#box(stack(
    dir: ttb,
    spacing: 1pt,
    text(size: 0.6em)[o],
    line(length: 0.35em, stroke: 0.6pt),
    v(0.3em)
))
]

#module[Introduction]
#keyword[SWE Triangle]: general - maintainable - fast.
#keyword[SMART]: Specific Measurable Acceptable Realisable Thorough.
#keyword[Parameters]: system/workload, numeric/nominal.
#keyword[Utilisation]: percentage of a resource being used to perform a
service.
#keyword[Bottleneck]: resource with the _highest_ utilisation.
#keyword[Critical path]: *sequential* part of code in a parallel application
that limits scaling through parallelisation.
#keyword[Hot path]: path that *takes the most time*. An ideal system has no
critical path.
#keyword[Numerical model]: predict performance by interpolation between
measured datapoints.
#keyword[Analytical model]: stateful (Markov, stochastic), stateless. A formal
characterisation of relationship between system parameters and performance
metrics.

#module[Tracing and Profiling]
#keyword[Trace]: complete log of every state the system was in.
#keyword[Perturbation]: system performance changing due to it being analysed.
Reduce perturbation by sacrificing fidelity.
#keyword[Time-based sampling]: set hardware recurrent timer and sample on
interrupt. CPU cycles are innacurate, non-deterministic, noisy.
#keyword[Quantisation error]: happens due to limited interval resolution.
#keyword[Indirect tracing]: some trace events are dominated by others. Sample
these instead: e.g. sample control-flow instructions to get an accurate trace.
Indirect tracing has good fidelity and accuracy.
#keyword[Profiling]: aggregation over a trace, focussing on specific metric.
Profiling is easy to interpret and aggregation reduces perturbation.
#keyword[Event sources]: software (library, compiler, kernel), hardware
(performance counters), emulator (hybrid).
#keyword[Instrumentation]: +no need for hardware support +flexible -overhead.
#keyword[Static binary instrumentation]: binary is modified by injecting
logging code. Reinstrumentation each time, cannot disable at runtime.
#keyword[Dynamic binary instrumentation]: no recompilation, performed on
running processes, works on JiT code.
Example: LLVM XRay.
#keyword[Software performance counters]: in kernel, e.g. packets sent, virtual
memory operations.
#keyword[Hardware performance counters]: special registers that count events.
Fixed #num of registers. Often buggy, poorly documented, can have bad accuracy.
#keyword[Pipeline]: Fetch #sym.arrow.r Decode #sym.arrow.r Execute
#sym.arrow.r Memory #sym.arrow.r Write.
#image("bottleneck_analysis.png")
