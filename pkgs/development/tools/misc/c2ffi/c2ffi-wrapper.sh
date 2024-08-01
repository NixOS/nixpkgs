#!/bin/sh

exec @c2ffi@ $@ -I . -i @libc@/include -i @clang@/resource-root/include $NIX_C2FFI_FLAGS
