/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*   Copyright 2025 Institut National de Recherche en Informatique et    */
/*     en Automatique.                                                    */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

/* USDT (Userland Statically Defined Tracing) probe definitions for OCaml
 *
 * This file defines USDT probes for tracing OCaml runtime events using
 * DTrace, SystemTap, bpftrace, and other compatible tracing tools.
 *
 * Probes are compiled as NOP instructions when not actively traced,
 * providing minimal overhead (~1-2ns per probe).
 *
 * These probes complement the existing runtime_events system:
 * - Runtime events: Ring buffer-based, OCaml-specific tooling
 * - USDT probes: System-wide tracing, standard Unix tools
 *
 * Usage:
 *   - On Linux: Requires systemtap-sdt-dev package
 *   - On macOS: Uses built-in DTrace support
 *   - On other Unix: Uses SystemTap SDT if available
 *
 * To enable USDT probes, configure must detect sys/sdt.h and define
 * CAML_WITH_USDT in config.h
 */

#ifndef CAML_USDT_PROBES_H
#define CAML_USDT_PROBES_H

#ifdef CAML_WITH_USDT

#ifdef __APPLE__
/* macOS uses native DTrace */
#include <sys/sdt.h>
#else
/* Linux and others use SystemTap SDT */
#if __has_include(<sys/sdt.h>)
#include <sys/sdt.h>
#else
/* sys/sdt.h not found - disable USDT even though CAML_WITH_USDT was set */
#undef CAML_WITH_USDT
#warning "CAML_WITH_USDT defined but sys/sdt.h not found, disabling USDT"
#endif
#endif

#endif /* CAML_WITH_USDT */

/* Provider name for all OCaml runtime probes */
#define OCAML_PROVIDER ocaml

/*
 * Probe definitions
 *
 * If USDT is enabled, these expand to DTRACE_PROBE macros which emit
 * NOP instructions and ELF metadata. If disabled, they expand to empty
 * statements with zero overhead.
 */

#ifdef CAML_WITH_USDT

/* ========================================================================
 * GC Phase Probes
 * ======================================================================== */

/* Minor GC - fired at start/end of minor collection
 * Maps to: CAML_EV_BEGIN(EV_MINOR) / CAML_EV_END(EV_MINOR)
 */
#define OCAML_USDT_GC_MINOR_BEGIN(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__minor__begin, domain_id)

#define OCAML_USDT_GC_MINOR_END(domain_id, promoted_words, allocated_words) \
    DTRACE_PROBE3(OCAML_PROVIDER, gc__minor__end, \
                  domain_id, promoted_words, allocated_words)

/* Major GC - fired at start/end of major collection phases
 * Maps to: CAML_EV_BEGIN(EV_MAJOR) / CAML_EV_END(EV_MAJOR)
 */
#define OCAML_USDT_GC_MAJOR_BEGIN(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__major__begin, domain_id)

#define OCAML_USDT_GC_MAJOR_END(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__major__end, domain_id)

/* Major GC Slice - fired for incremental major GC slices
 * Maps to: CAML_EV_BEGIN(EV_MAJOR_SLICE) / CAML_EV_END(EV_MAJOR_SLICE)
 */
#define OCAML_USDT_GC_MAJOR_SLICE_BEGIN(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__major__slice__begin, domain_id)

#define OCAML_USDT_GC_MAJOR_SLICE_END(domain_id, marked_words) \
    DTRACE_PROBE2(OCAML_PROVIDER, gc__major__slice__end, domain_id, marked_words)

/* Heap Compaction - fired for rare but expensive compaction events
 * Maps to: CAML_EV_BEGIN(EV_COMPACT) / CAML_EV_END(EV_COMPACT)
 */
#define OCAML_USDT_GC_COMPACT_BEGIN(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__compact__begin, domain_id)

#define OCAML_USDT_GC_COMPACT_END(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, gc__compact__end, domain_id)

/* ========================================================================
 * Allocation Probes
 * ======================================================================== */

/* Minor heap allocation
 * Maps to: CAML_EV_COUNTER(EV_C_MINOR_ALLOCATED_WORDS, ...)
 * Note: High frequency - use with filtering in tracer
 */
#define OCAML_USDT_ALLOC_MINOR(domain_id, size_words) \
    DTRACE_PROBE2(OCAML_PROVIDER, alloc__minor, domain_id, size_words)

/* Major heap allocation
 * Maps to: CAML_EV_COUNTER(EV_C_MAJOR_ALLOCATED_WORDS, ...)
 */
#define OCAML_USDT_ALLOC_MAJOR(domain_id, size_words) \
    DTRACE_PROBE2(OCAML_PROVIDER, alloc__major, domain_id, size_words)

/* ========================================================================
 * Domain/Thread Lifecycle Probes
 * ======================================================================== */

/* Domain spawn
 * Maps to: CAML_EV_LIFECYCLE(EV_DOMAIN_SPAWN, ...)
 */
#define OCAML_USDT_DOMAIN_SPAWN(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, domain__spawn, domain_id)

/* Domain termination
 * Maps to: CAML_EV_LIFECYCLE(EV_DOMAIN_TERMINATE, ...)
 */
#define OCAML_USDT_DOMAIN_TERMINATE(domain_id) \
    DTRACE_PROBE1(OCAML_PROVIDER, domain__terminate, domain_id)

/* ========================================================================
 * Runtime Lifecycle Probes
 * ======================================================================== */

/* Runtime initialization complete
 * Maps to: EV_RING_START lifecycle event
 */
#define OCAML_USDT_RUNTIME_BEGIN() \
    DTRACE_PROBE(OCAML_PROVIDER, runtime__begin)

/* Runtime shutdown beginning
 * Maps to: EV_RING_STOP lifecycle event
 */
#define OCAML_USDT_RUNTIME_END() \
    DTRACE_PROBE(OCAML_PROVIDER, runtime__end)

/* ========================================================================
 * STW (Stop-The-World) Event Probes
 * ======================================================================== */

/* STW event beginning - all domains pausing for coordination
 * Maps to: CAML_EV_BEGIN(EV_STW_LEADER) / EV_STW_HANDLER / EV_MAJOR_GC_STW
 * reason: 0=GC, 1=API_BARRIER, 2=other
 */
#define OCAML_USDT_STW_BEGIN(domain_id, reason) \
    DTRACE_PROBE2(OCAML_PROVIDER, stw__begin, domain_id, reason)

/* STW event complete
 * duration_ns: time spent in STW in nanoseconds
 */
#define OCAML_USDT_STW_END(domain_id, duration_ns) \
    DTRACE_PROBE2(OCAML_PROVIDER, stw__end, domain_id, duration_ns)

/* ========================================================================
 * Memory Heap Statistics Probes
 * ======================================================================== */

/* Heap statistics snapshot
 * Aggregates: EV_C_MAJOR_HEAP_WORDS, EV_C_MINOR_ALLOCATED_WORDS, etc.
 * Fired periodically or after major GC events
 */
#define OCAML_USDT_HEAP_STATS(domain_id, minor_words, major_words, live_words) \
    DTRACE_PROBE4(OCAML_PROVIDER, heap__stats, \
                  domain_id, minor_words, major_words, live_words)

/* ========================================================================
 * Probe Enabled Checks
 * ========================================================================
 *
 * These allow avoiding expensive argument computation when probe is not
 * actively being traced. Use pattern:
 *   if (OCAML_USDT_GC_MINOR_BEGIN_ENABLED()) {
 *       expensive_calculation();
 *       OCAML_USDT_GC_MINOR_BEGIN(domain_id);
 *   }
 */

#define OCAML_USDT_GC_MINOR_BEGIN_ENABLED() \
    DTRACE_PROBE_ENABLED(OCAML_PROVIDER, gc__minor__begin)

#define OCAML_USDT_GC_MAJOR_BEGIN_ENABLED() \
    DTRACE_PROBE_ENABLED(OCAML_PROVIDER, gc__major__begin)

#define OCAML_USDT_ALLOC_MINOR_ENABLED() \
    DTRACE_PROBE_ENABLED(OCAML_PROVIDER, alloc__minor)

#define OCAML_USDT_HEAP_STATS_ENABLED() \
    DTRACE_PROBE_ENABLED(OCAML_PROVIDER, heap__stats)

#else /* !CAML_WITH_USDT */

/* ========================================================================
 * No-op definitions when USDT is not available
 * ======================================================================== */

#define OCAML_USDT_GC_MINOR_BEGIN(domain_id) do {} while(0)
#define OCAML_USDT_GC_MINOR_END(domain_id, promoted_words, allocated_words) do {} while(0)
#define OCAML_USDT_GC_MAJOR_BEGIN(domain_id) do {} while(0)
#define OCAML_USDT_GC_MAJOR_END(domain_id) do {} while(0)
#define OCAML_USDT_GC_MAJOR_SLICE_BEGIN(domain_id) do {} while(0)
#define OCAML_USDT_GC_MAJOR_SLICE_END(domain_id, marked_words) do {} while(0)
#define OCAML_USDT_GC_COMPACT_BEGIN(domain_id) do {} while(0)
#define OCAML_USDT_GC_COMPACT_END(domain_id) do {} while(0)
#define OCAML_USDT_ALLOC_MINOR(domain_id, size_words) do {} while(0)
#define OCAML_USDT_ALLOC_MAJOR(domain_id, size_words) do {} while(0)
#define OCAML_USDT_DOMAIN_SPAWN(domain_id) do {} while(0)
#define OCAML_USDT_DOMAIN_TERMINATE(domain_id) do {} while(0)
#define OCAML_USDT_RUNTIME_BEGIN() do {} while(0)
#define OCAML_USDT_RUNTIME_END() do {} while(0)
#define OCAML_USDT_STW_BEGIN(domain_id, reason) do {} while(0)
#define OCAML_USDT_STW_END(domain_id, duration_ns) do {} while(0)
#define OCAML_USDT_HEAP_STATS(domain_id, minor_words, major_words, live_words) do {} while(0)

#define OCAML_USDT_GC_MINOR_BEGIN_ENABLED() 0
#define OCAML_USDT_GC_MAJOR_BEGIN_ENABLED() 0
#define OCAML_USDT_ALLOC_MINOR_ENABLED() 0
#define OCAML_USDT_HEAP_STATS_ENABLED() 0

#endif /* CAML_WITH_USDT */

#endif /* CAML_USDT_PROBES_H */
