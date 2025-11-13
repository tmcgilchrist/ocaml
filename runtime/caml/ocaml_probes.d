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
 * This file defines all USDT probes for the OCaml runtime.
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
     * GC Phase Probes
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

    /* Heap Compaction - fired for rare but expensive compaction events */
    probe gc__compact__begin(int domain_id);
    probe gc__compact__end(int domain_id);

    /*
     * Allocation Probes
     */

    /* Minor heap allocation */
    probe alloc__minor(int domain_id, uint64_t size_words);

    /* Major heap allocation */
    probe alloc__major(int domain_id, uint64_t size_words);

    /*
     * Domain/Thread Lifecycle Probes
     */

    probe domain__spawn(int domain_id);
    probe domain__terminate(int domain_id);

    /*
     * Runtime Lifecycle Probes
     */

    probe runtime__begin();
    probe runtime__end();

    /*
     * STW (Stop-The-World) Event Probes
     */

    probe stw__begin(int domain_id, int reason);
    probe stw__end(int domain_id, uint64_t duration_ns);

    /*
     * Memory Heap Statistics Probes
     */

    probe heap__stats(int domain_id, uint64_t minor_words,
                     uint64_t major_words, uint64_t live_words);

    /*
     * Runtime Event Counter Probes - Minor GC
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
     * Major GC Heap Statistics Counters
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
};
