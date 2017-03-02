#!/bin/sh

nm -jgU -arch x86_64 /usr/lib/system/libsystem_c.dylib > system_c_symbols_x86_64
nm -jgU -arch i386 /usr/lib/system/libsystem_c.dylib > system_c_symbols_i386
nm -jgU -arch x86_64 /usr/lib/system/libsystem_kernel.dylib > system_kernel_symbols_x86_64
nm -jgU -arch i386 /usr/lib/system/libsystem_kernel.dylib > system_kernel_symbols_i386
