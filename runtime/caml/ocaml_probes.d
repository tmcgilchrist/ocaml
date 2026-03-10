/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*                         Tim McGilchrist, Tarides                       */
/*                                                                        */
/*   Copyright 2025 Tarides                                               */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

/*
 * ocaml_probes.d - OCaml USDT Provider Definition
 *
 * This file defines the USDT probes for the OCaml runtime.
 * It is used to generate probe headers on macOS and FreeBSD using:
 *   dtrace -h -s ocaml_probes.d -o ocaml_probes.h
 *
 * And to generate probe object code with:
 *   dtrace -G -s ocaml_probes.d -o ocaml_probes.o object_files.o
 *
 * On Linux with SystemTap SDT, this file is not used - the DTRACE_PROBE
 * macros from <sys/sdt.h> are used directly.
 */

provider ocaml {
    /*
     * Garbage Collection (GC) phase
     */

    /* Minor GC - fired at start/end of minor collection */
    probe gc__minor__begin(int domain_id);
    probe gc__minor__end(int domain_id, uint64_t promoted_words,
                         uint64_t allocated_words);

    /* Major GC - fired at start/end of major collection phases */
    probe gc__major__begin(int domain_id);
    probe gc__major__end(int domain_id);

    /* Major GC Slice - fired for incremental major GC slices */
    probe gc__major__slice__begin(int domain_id);
    probe gc__major__slice__end(int domain_id, uint64_t marked_words);

    /* Heap Compaction - fired at start/end of compaction */
    probe gc__compact__begin(int domain_id);
    probe gc__compact__end(int domain_id);

    /*
     * Minor GC sub-phases (ev_runtime_phase)
     */
    probe gc__minor__local__roots__begin(int domain_id);
    probe gc__minor__local__roots__end(int domain_id);
    probe gc__minor__local__roots__promote__begin(int domain_id);
    probe gc__minor__local__roots__promote__end(int domain_id);
    probe gc__minor__memprof__roots__begin(int domain_id);
    probe gc__minor__memprof__roots__end(int domain_id);
    probe gc__minor__memprof__clean__begin(int domain_id);
    probe gc__minor__memprof__clean__end(int domain_id);
    probe gc__minor__ephe__clean__begin(int domain_id);
    probe gc__minor__ephe__clean__end(int domain_id);
    probe gc__minor__finalized__begin(int domain_id);
    probe gc__minor__finalized__end(int domain_id);
    probe gc__minor__finalizers__oldify__begin(int domain_id);
    probe gc__minor__finalizers__oldify__end(int domain_id);
    probe gc__minor__finalizers__admin__begin(int domain_id);
    probe gc__minor__finalizers__admin__end(int domain_id);
    probe gc__minor__clear__begin(int domain_id);
    probe gc__minor__clear__end(int domain_id);
    probe gc__minor__global__roots__begin(int domain_id);
    probe gc__minor__global__roots__end(int domain_id);
    probe gc__minor__remembered__set__begin(int domain_id);
    probe gc__minor__remembered__set__end(int domain_id);
    probe gc__minor__remembered__set__promote__begin(int domain_id);
    probe gc__minor__remembered__set__promote__end(int domain_id);
    probe gc__minor__leave__barrier__begin(int domain_id);
    probe gc__minor__leave__barrier__end(int domain_id);
    probe gc__empty__minor__begin(int domain_id);
    probe gc__empty__minor__end(int domain_id);

    /*
     * Major GC sub-phases (ev_runtime_phase)
     */
    probe gc__major__sweep__begin(int domain_id);
    probe gc__major__sweep__end(int domain_id);
    probe gc__major__mark__roots__begin(int domain_id);
    probe gc__major__mark__roots__end(int domain_id);
    probe gc__major__mark__begin(int domain_id);
    probe gc__major__mark__end(int domain_id);
    probe gc__major__mark__opportunistic__begin(int domain_id);
    probe gc__major__mark__opportunistic__end(int domain_id);
    probe gc__major__memprof__roots__begin(int domain_id);
    probe gc__major__memprof__roots__end(int domain_id);
    probe gc__major__memprof__clean__begin(int domain_id);
    probe gc__major__memprof__clean__end(int domain_id);
    probe gc__major__ephe__mark__begin(int domain_id);
    probe gc__major__ephe__mark__end(int domain_id);
    probe gc__major__ephe__sweep__begin(int domain_id);
    probe gc__major__ephe__sweep__end(int domain_id);
    probe gc__major__finish__marking__begin(int domain_id);
    probe gc__major__finish__marking__end(int domain_id);
    probe gc__major__finish__sweeping__begin(int domain_id);
    probe gc__major__finish__sweeping__end(int domain_id);
    probe gc__major__finish__cycle__begin(int domain_id);
    probe gc__major__finish__cycle__end(int domain_id);
    probe gc__major__gc__cycle__domains__begin(int domain_id);
    probe gc__major__gc__cycle__domains__end(int domain_id);
    probe gc__major__gc__phase__change__begin(int domain_id);
    probe gc__major__gc__phase__change__end(int domain_id);
    probe gc__major__gc__stw__begin(int domain_id);
    probe gc__major__gc__stw__end(int domain_id);

    /*
     * Compaction sub-phases (ev_runtime_phase)
     */
    probe gc__compact__evacuate__begin(int domain_id);
    probe gc__compact__evacuate__end(int domain_id);
    probe gc__compact__forward__begin(int domain_id);
    probe gc__compact__forward__end(int domain_id);
    probe gc__compact__release__begin(int domain_id);
    probe gc__compact__release__end(int domain_id);

    /*
     * Explicit GC calls (ev_runtime_phase)
     */
    probe explicit__gc__set__begin(int domain_id);
    probe explicit__gc__set__end(int domain_id);
    probe explicit__gc__stat__begin(int domain_id);
    probe explicit__gc__stat__end(int domain_id);
    probe explicit__gc__minor__begin(int domain_id);
    probe explicit__gc__minor__end(int domain_id);
    probe explicit__gc__major__begin(int domain_id);
    probe explicit__gc__major__end(int domain_id);
    probe explicit__gc__full__major__begin(int domain_id);
    probe explicit__gc__full__major__end(int domain_id);
    probe explicit__gc__compact__begin(int domain_id);
    probe explicit__gc__compact__end(int domain_id);
    probe explicit__gc__major__slice__begin(int domain_id);
    probe explicit__gc__major__slice__end(int domain_id);

    /*
     * Finaliser phases (ev_runtime_phase)
     */
    probe finalise__update__first__begin(int domain_id);
    probe finalise__update__first__end(int domain_id);
    probe finalise__update__last__begin(int domain_id);
    probe finalise__update__last__end(int domain_id);

    /*
     * Domain runtime phases (ev_runtime_phase)
     */
    probe domain__condition__wait__begin(int domain_id);
    probe domain__condition__wait__end(int domain_id);
    probe domain__resize__heap__reservation__begin(int domain_id);
    probe domain__resize__heap__reservation__end(int domain_id);

    /*
     * STW (Stop-The-World) life cycle
     */
    probe stw__begin(int domain_id, int reason);
    probe stw__end(int domain_id, uint64_t duration_ns);

    /* STW synchronisation tracking */
    probe stw__interrupt__sent(int leader_id, int target_domain_id);
    probe stw__handler__enter(int domain_id);
    probe stw__barrier__enter(int domain_id, int barrier_id);

    /*
     * STW phases
     */
    probe stw__api__barrier__begin(int domain_id);
    probe stw__api__barrier__end(int domain_id);
    probe stw__handler__begin(int domain_id);
    probe stw__handler__end(int domain_id);
    probe stw__leader__begin(int domain_id);
    probe stw__leader__end(int domain_id);

    /*
     * Interrupt (ev_runtime_phase)
     * TODO What does this map to in the GC algorithm?
     */
    probe interrupt__remote__begin(int domain_id);
    probe interrupt__remote__end(int domain_id);

    /* Minor heap allocation */
    probe alloc__minor(int domain_id, uint64_t size_words);

    /* Major heap allocation */
    probe alloc__major(int domain_id, uint64_t size_words);

    /*
     * Domain life cycle
     */
    probe domain__spawn(int domain_id);
    probe domain__terminate(int domain_id);

    /*
     * Runtime life cycle
     */
    probe runtime__begin();
    probe runtime__end();


    /*
     * Memory Heap Statistics
     * TODO Do we need this, is there an equivalent selection of counters we could use instead? It doesn't directly map to a runtime event.
     */
    probe heap__stats(int domain_id, uint64_t minor_words,
                     uint64_t major_words, uint64_t live_words);

    /*
     * Minor GC statistics
     */
    probe counter__minor__promoted(int domain_id, uint64_t bytes);
    probe counter__minor__promoted__words(int domain_id, uint64_t words);
    probe counter__minor__allocated(int domain_id, uint64_t bytes);
    probe counter__minor__allocated__words(int domain_id, uint64_t words);

    /*
     * Force Minor GC Counters
     */
    probe counter__force__minor__alloc__small(int domain_id);
    probe counter__force__minor__make__vect(int domain_id);
    probe counter__force__minor__set__minor__heap__size(int domain_id);
    probe counter__force__minor__memprof(int domain_id);

    /*
     * Major GC heap statistics counters
     */
    probe counter__major__heap__words(int domain_id, uint64_t words);
    probe counter__major__heap__pool__words(int domain_id, uint64_t words);
    probe counter__major__heap__pool__live__words(int domain_id, uint64_t words);
    probe counter__major__heap__large__words(int domain_id, uint64_t words);
    probe counter__major__heap__pool__frag__words(int domain_id, uint64_t words);
    probe counter__major__heap__pool__live__blocks(int domain_id, uint64_t blocks);
    probe counter__major__heap__large__blocks(int domain_id, uint64_t blocks);

    /*
     * Major GC Work Counters
     */

    probe counter__major__allocated__words(int domain_id, uint64_t words);
    probe counter__major__allocated__work(int domain_id, uint64_t work);
    probe counter__major__dependent__work(int domain_id, uint64_t work);
    probe counter__major__extra__work(int domain_id, uint64_t work);
    probe counter__major__work__counter(int domain_id, uint64_t cnt);
    probe counter__major__alloc__counter(int domain_id, uint64_t cnt);
    probe counter__major__slice__target(int domain_id, uint64_t target);
    probe counter__major__slice__budget(int domain_id, uint64_t budget);

    /*
     * Request Counters
     */

    probe counter__request__major__alloc__shr(int domain_id);
    probe counter__request__major__adjust__gc__speed(int domain_id);
    probe counter__request__minor__realloc__ref__table(int domain_id);
    probe counter__request__minor__realloc__ephe__ref__table(int domain_id);
    probe counter__request__minor__realloc__custom__table(int domain_id);

    /*
     * TODO Missing USDT probes that could be added
     * 1. Thread lifecycle (see devlog/2026-02-25-thread-lifecycle-probes.md)
     * 2. ev_lifecycle: ring start/stop/pause/resume, fork parent/child
     */
};
