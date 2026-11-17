/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*                         The OCaml programmers                          */
/*                                                                        */
/*   Copyright 2026 Institut National de Recherche en Informatique et     */
/*     en Automatique.                                                    */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include "caml/unixsupport.h"
#include <windows.h>

/* The number this library uses to identify a process is a process handle,
   not the identifier the operating system uses: [caml_unix_getpid] returns a
   handle to the current process and [caml_unix_create_process] returns the
   handle from [CreateProcess]. These convert between the two. */

CAMLprim value caml_unix_getpid_os(value unit)
{
  return caml_copy_int32((int32_t) GetCurrentProcessId());
}

CAMLprim value caml_unix_os_pid_of_process(value pid)
{
  DWORD os_pid = GetProcessId((HANDLE) Long_val(pid));
  /* [GetProcessId] reports failure by returning 0, which Windows never
     assigns to a process. */
  if (os_pid == 0) {
    caml_win32_maperr(GetLastError());
    caml_uerror("os_pid_of_process", Nothing);
  }
  return caml_copy_int32((int32_t) os_pid);
}

CAMLprim value caml_unix_process_of_os_pid(value os_pid)
{
  /* These are the access rights the rest of the library needs from a process
     handle: [caml_unix_waitpid] waits on it and reads its exit code, and
     [caml_unix_terminate_process] terminates it. Like the handle from
     [caml_unix_create_process], this one is the caller's to close, which
     [caml_unix_waitpid] does. */
  HANDLE h = OpenProcess(SYNCHRONIZE | PROCESS_QUERY_INFORMATION
                         | PROCESS_TERMINATE,
                         FALSE, (DWORD) Int32_val(os_pid));
  if (h == NULL) {
    caml_win32_maperr(GetLastError());
    caml_uerror("process_of_os_pid", Nothing);
  }
  return Val_long(h);
}
