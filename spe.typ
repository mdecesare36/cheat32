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

// Part 1
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
#keyword[Control dependency stall]: e.g. branch misprediction causing
pipeline flush.
#keyword[Resource stall]: execution unit (e.g. ALU) not available. Long
instructions can also cause pipeline bubbles.
#keyword[Frontend-bound]: usually control-flow dependency pipeline flush
or instruction cache miss.
#keyword[Other stalls]: usually due to expensive ALU operations.
#grid(
    columns: 2,
    image("bottleneck_analysis.png"),
    [
        #module[Modelling]
        we want to know performance without running the system, for cost
        estimation, provisioning systems and runtime optimisation/tuning.
        #keyword[Numerical model]: based on empirical datapoints gathered
        using *microbenchmarks*.
    ]
)
#keyword[Microbenchmark]: small program designed to test specific portion of
a system.
Numerical models:  easy, based on ground truth, generalise poorly, lots of
data needed for high-dimensional parameter spaces, limited insight.
#keyword[Analytical models]: require understanding. Needs a *characteristic
equation*. Can use #keyword[model fitting], e.g. linear regression.
As stride varies, memory access time is given by:
$
T_"Mem" = sum_(i=o)^3 l_i dot.op min(1, s/B_i)
$
As array size changes, memory access is given by:
$
T_"Mem" = cases(
    l_0 & "size"<C_1,
    l_0 + l_1 & "size"<C_2,
    l_0 + l_1 + l_2 & "size"<C_3,
    l_0 + l_1 + l_2 + l_3 & "otherwise"
)
$
#keyword[Sequential memory access]: reading $u$ words then skipping
$(R.w - u)$ words $R.n$ times.
#keyword[Random access]: with repetitive access to elements. We have $R.w$,
$u$, $||R||$ and an additional parameter $r$ - the number of accesses.
#keyword[Complex patterns]: define operators for sequential execution 
$cal(P)_1 plus.o cal(P)_2$ and concurrent execution $cal(P)_1 dot.o cal(P)_2$.
Example: $"s_trav"(R.w=1, u=1, R.n=1024) dot.o "rr_acc"(R.w=1, u=2, R.n=64,
r=1024)$
#keyword[Branch predictors]: CPU stores _pattern history table_ with four
states: strongly not taken, weakly not taken, weakly taken, strongly taken.
Branch misprediction rate is $P("pred_taken")dot.op P("act_not_taken") +
P("pred_not_taken") dot.op P("act_taken")$. These probabilities can be found
using the stationary distribution of the Markov model.

#module[Efficient code]
#keyword[Balanced system]: one without a bottleneck where all resources are
equally utilised.
#keyword[Amdahl's Second Law]: A *balanced* computer system needs 1 MB of main
memory and 1 Mb/s of I/O bandwidth per MIPS of CPU performance.
Balance is not constant: datatypes are larger today, CPUs have many
coprocessors, cache lines are larger. Balance is also a function of code:
impacted by hardware optimisations. Perfect balance is an unachievable ideal.
There is no balanced system, only sections of balanced code.
We distinguish four types of code: #keyword[balanced], #keyword[compute-bound],
#keyword[latency-bound], #keyword[bandwidth-bound].
#keyword[Compute-bound]: related to CPU efficiency. Main metric: wallclock
time. Stall cycles are a good indicator and are caused by _hazards_: control
hazards, structural hazards (structure of CPU, i.e. lack of execution
resources), data hazards (operands not available in time). These hazards can
be mitigated in hardware by making more resources available.
#keyword[Speculative execution]: branch + jump prediction.
#keyword[Superscalar execution]: execute instructions in parallel by having
more than one pipeline.
#keyword[Out-of-order execution]: after decoding, CPU identifies instruction
dependencies, allowing an instruction to overtake those it doesn't depend on.
#keyword[SIMD]. #keyword[VLIW]: compiler-controlled superscalar.
#keyword[Partial evaluation]: inlining, constant folding, metaprogramming, ...
#keyword[If-conversion]: change branching to branch-free code. Turns control
dependencies to data dependencies. Not worthwhile for predictable code.
#keyword[Data hazard]: pipeline stall due to cache miss (capacity miss or
compulsory miss).

#grid(
    columns: 2,
    image("memory_optimisations.png"),
    [
        #keyword[Hardware prefetching]: speculatively load next cache line,
        recognising patterns like adjacent cache lines, strides, ...
        #keyword[Software prefetching]: hint using
        `__builtin_prefetch(void *addr)`
    ]
)

#keyword[Cache-line utilisation] = data used by instructions #sym.div data
loaded into cache.
#keyword[Thrashing]: can be fixed using #keyword[loop tiling].
#keyword[MESI]: Modified, Exclusive, Shared, Invalid.
#keyword[False sharing]: another control-flow hazard.

//#pagebreak()
#linebreak()

// Part 2
#module[Multi-Core and Parallelism]
#keyword[Amdahl's Law]:
$
"Speedup"(p,s) = 1 div ((1-p) + p/s)
$
#keyword[Synchronisation primitives]: `std::mutex`, `std::unique_lock`,
`std::lock_guard`, `std::counting_semaphore`, `std::binary_semaphore`,
`std::shared_lock`, `std::condition_variable`, `std::barrier`.
#keyword[False sharing]: parallel access to separate variables that live in
the same cache line. Measure _cache line contention_ through #keyword[HITM]
count in `perf c2c`.
#keyword[Naive threading]: when #num threads > #num cores: thread creation
overhead, context switching/scheduling overhead, cache locality degradation,
lock contention.
Solution: #keyword[thread pool]. Either split jobs equally between threads, or
use shared job queue to enable work stealing.
#keyword[Streaming]: pipeline with concurrent stages (assembly line). Good
locality for code & temporary data, bad locality for input/output data.
#keyword[SEDA]: Staged Event-Driven Architecture. Modular stages w/ pools and
input queue per stage. Bottlenecks are explicit (full queue). Observable load -
can react by changing queue length, #num threads per stage. Very flexible
tuning, ut stages across threads hurt performance (cache locality).
#keyword[Multi-processing]: no shared memory, *expensive* communication. Can
use explicit shared memory, sockets, pipes.

#module[Tools, Algorithms and Patterns]
#keyword[Blocking algorithms]: involve locking on critical sections, causing
other threads to block. If a thread has a lock and gets de-scheduled, every
other thread wanting that lock must wait.
#keyword[Non-blocking]: suspension of one thread cannot cause suspension of
other threads. Uses atomic RMW without locking.
#keyword[Lock-free]: at least one thread is guaranteed to progress.
#keyword[Wait-free]: every thread is guaranteed to progress.
#keyword[ABA Problem]: wrong assumption that `head` being the same in the CAS
also means `head->next` is the same. This can lead to `head` being assigned
an out-of-date `head->next` that may have been freed.
#module[System Interfaces and Performance]
#keyword[Syscall anatomy]: [user mode] store args in registers, syscall
instr, [kernel mode] sanitize env, save state, execute handler, restore
state, sys return instr, [user mode].
#keyword[Buffered IPC]: #text(fill: green)[non-blocking], #text(fill: red)[2x
data copies].
#keyword[Unbuffered IPC]: #text(fill: red)[blocking], #text(fill: green)[1x
data copies].
#keyword[Partial walk cache]: cache partial page table traversals.
#keyword[TLB shootdown]: when a PTE is modified (e.g. `munmap` or page
downgrade), the kernel sends IPIs to every core with that
address space active to flush their TLB entries. The interrupts cause pipeline
flushes, and the core that issued this needs to wait until all flushes have
occurred. Solutions: avoid downgrades, asynchronous downgrade syscalls, hw
acceleration.
#keyword[Virtualisation]: #text(fill: green)[reduce cost by sharing same
physical machine, more secure than containers/processes]. #text(fill: red)[VM
exceptions are *expensive*; long microcode to switch from guest/host,
saves/restores several registers].
#keyword[Virtual memory translation]: let hypervisor manage PTs
(#keyword[shadow paging]); expensive vm-exits to manage guest PTs. Or use guest
and host PWCs.
#keyword[MMIO]: Use PCIe BARs (base addr registers), circular buffer in host
memory and BARs configure queue changes.
#keyword[Device driver models]: interrupt-driven, polling (using MMIO reads),
hybrid (dynamically switch to polling if latency is low).
#keyword[Device virtualisation models]: trap & emulate (*very expensive*),
para-virtualised (map shared memory between VM & hypervisor, trapped MMIO
access as doorbell signal), passthrough (map device BARs into VM & configure
IOMMU, devices need one set of BARs per VM).
#keyword[Non-blocking interfaces] avoid context switch & data copy. Can be
asynchronous or event-based.
#keyword[Asynchronous interfaces]: kernel signals end of operation.
#keyword[Event-based interfaces]: express interest on ops on FDs. Poll kernel
for available ops in event loop, e.g. `epoll` tells you when a socket is ready
to read from.
#keyword[Direct device assignment]: bypass kernel with user-mode MMIO, e.g.
DPDK.
#module[System Programming Models]
#keyword[One-thread per task]: main thread spawns worker thread for each new
connection. Thread creation is expensive (time + memory), spends lots of time
context switching.
#keyword[Worker pools]: #text(fill: green)[avoids cost of on0demand thread
creation], #text(fill: red)[no clients processed when workers are blocked,
still has context switch overhead if #num threads > #num CPUs].
#keyword[Event-based]: pin one thread per core, use non-blocking IO, keep
state machine to track each concurrent context. #text(fill: green)[no thread
scheduling, minimal memory usage], #text(fill: red)[complicated to program].
#keyword[Memcached]: in-memory key/value store. #text(fill: red)[calls to
read/write incur copies, bad locality at high load (app. & network stack data &
locks go across cores)].
#keyword[IX]: NIC uses ECMP to steer packets to cores. VM with NIC passthrough,
zero copy, syscall batching, end-to-end processing maximises cache locality.
#module[Scale-Out Systems]
#keyword[Energy proportionality]: ideally energy consumption #sym.prop
utilization. Reality: substantial minimum cost + energy at low loads. Best
value when hardware is off, or at max utilisation.
Increasing utilisation does reduce cost but can easily violate SLO.
#keyword[Elasticity]: ability to adapt to local changes, e.g. add/remove CPUs
according to load.
#keyword[Scale-out]: *handle failures*.
#keyword[Microservices]: one service for each task, increase capacity by
increasing instances. Complex management, distribution, VMs have expensive boot
time. Can isolate tenants with VMs and isolate services using containers.
#keyword[Serverless]: tenant only declares what to run, on certain events.
Operator load-balances & auto-scales.
#keyword[The standing problem]: starting and stopping serverless instances is
expensive: container creation (setting up namespaces), service boot (runtime
initialisation). Solution: *cache and prefetch*.
#keyword[Function-as-a-service] (FaaS): tenant provides business logic and
*trigger* stateless function. Tenants use separate VMs (security), one
container + runtime per function. Limited VM/container/runtime configs, easier
to predict, prefetch and reuse.
#module[Communication Mechanisms]
HTTP REST + JSON most common solution.
#keyword[RPCs]: remote procedure calls. Server API defined as function calls
(usually asynchronous). Frameworks: gRPC, protobuf, ... Binary-based: more
efficient to transfer & compress.
#keyword[The standing problem]: RESTful code & RPC stubs transfer lots of data
buffers. Lots of cycles spent on data transfer alone: allocate/free &
send/receive buffers.
#keyword[RDMA]: Remote DMA. Two types of primitives: stream (send/receive) &
memory (read/write). Two modes: reliable & unreliable. #text(fill: green)[moves
network stack into NIC; less CPU load], #text(fill: red)[hard to program]. OS
needs to send virtual #sym.arrow.r physical memory translations to NIC. Paging
application memory out requires telling NIC to invalidate its translations
(expensive).
#keyword[Tail latency]: key performance goal. Caused by transient overheads
(lock contention, TLB misses, etc.) and app-level differences (e.g. get vs
set). Utilisation #sym.arrow.b tail latency #sym.arrow.b, utilisation
#sym.arrow.t costs #sym.arrow.b.
#keyword[Load balancing]: distributing requests over resources. Can distribute
over _time_, _data_. Scale: _cross-core_, _cross-machine_.
#module[Queueing Theory]
three main parameters define *service latency*: arrival distribution (Poisson),
arrival assignment, service time distribution (ideally constant, realistically
exponential).
#keyword[Parameters]: single-queue vs multi-queue, FCFS vs processor sharing.
#keyword[Goals]: low tail latency, #keyword[work conservation] (core never idle
if there's work to do).
#image("queues.png")
#keyword[IX]: lower tail latency, 32xM/G/1/FCFS system. Perfect on
constant/exponential service times. Designed to "narrow" exponential dist.
HOL on bimodal service dist.
#keyword[ZygOS]: scale-up, almost single-queue, supports large service
dispersion, work-conserving, avoids HOL blocking.
#keyword[R2P2]: scale-out, towards single queue for all service instances.
Global queue when establishing connection, regular client/server connection
after, doesn't rebalance long-lived connections, reduce tail latency due to
overloaded nodes.
#keyword[Load proportionality]: PEGASUS; monitor app metrics, use DVVFS to
change core speed (power). #keyword[Scale-out] has large waste when nodes are
underutilised: exploit elasticity. Microservices make it simple, serverless &
FaaS make it efficient, FaaS make it adaptable.
