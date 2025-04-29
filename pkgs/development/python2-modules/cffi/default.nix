{
  lib,
  stdenv,
  cffi,
}:

if cffi == null then
  null
else
  cffi.overridePythonAttrs {
    disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
      # cannot load library 'c'
      "test_FILE"
      "test_FILE_object"
      "test_FILE_only_for_FILE_arg"
      "test_load_and_call_function"
      "test_load_library"

      # cannot load library 'dl'
      "test_dlopen_handle"

      # cannot load library 'm'
      "test_dir_on_dlopen_lib"
      "test_dlclose"
      "test_dlopen"
      "test_dlopen_constant"
      "test_dlopen_flags"
      "test_function_typedef"
      "test_line_continuation_in_defines"
      "test_missing_function"
      "test_remove_comments"
      "test_remove_line_continuation_comments"
      "test_simple"
      "test_sin"
      "test_sinf"
      "test_stdcall_only_on_windows"
      "test_wraps_from_stdlib"

      # MemoryError
      "test_callback_as_function_argument"
      "test_callback_crash"
      "test_callback_decorator"
      "test_callback_large_struct"
      "test_callback_returning_void"
      "test_cast_functionptr_and_int"
      "test_function_pointer"
      "test_functionptr_intptr_return"
      "test_functionptr_simple"
      "test_functionptr_void_return"
      "test_functionptr_voidptr_return"
    ];
  }
