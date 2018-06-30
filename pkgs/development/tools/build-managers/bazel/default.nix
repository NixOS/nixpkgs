{ stdenv, lib, writeText, writeScript, fetchurl, jdk, zip, unzip, bash, writeCBin, coreutils, binutils, makeWrapper, which, python, gnused
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
# Apple dependencies
, cctools, clang, libcxx, CoreFoundation, CoreServices, Foundation
}:

stdenv.mkDerivation rec {

  version = "0.13.0";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.mboes ];
    platforms = platforms.linux ++ platforms.darwin;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "143nd9dmw2x88azf8spinl2qnvw9m8lqlqc765l9q2v6hi807sc2";
  };

  sourceRoot = ".";

  patches = lib.optional enableNixHacks ./nix-hacks.patch;

  # Bazel expects several utils to be available in Bash even without PATH. Hence this hack.

  customBash = writeCBin "bash" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>

    extern char **environ;

    int main(int argc, char *argv[]) {
      char *path = getenv("PATH");
      char *pathToAppend = "${lib.makeBinPath [ coreutils gnused ]}";
      char *newPath;
      if (path != NULL) {
        int length = strlen(path) + 1 + strlen(pathToAppend) + 1;
        newPath = malloc(length * sizeof(char));
        snprintf(newPath, length, "%s:%s", path, pathToAppend);
      } else {
        newPath = pathToAppend;
      }
      setenv("PATH", newPath, 1);
      execve("${bash}/bin/bash", argv, environ);
      return 0;
    }
  '';

  buildFile = writeText "BUILD" ''
    package(default_visibility = ['//visibility:public'])

    filegroup(name = "empty")

    cc_toolchain_suite(
      name = "nix",
      toolchains = {
        "darwin|compiler": ":nix_darwin_toolchain",
        "k8|compiler": ":nix_linux_toolchain",
      },
    )

    cc_toolchain(
      name = "nix_darwin_toolchain",
      all_files = ":osx_wrapper",
      compiler_files = ":osx_wrapper",
      cpu = "darwin",
      dwp_files = ":empty",
      dynamic_runtime_libs = [":empty"],
      linker_files = ":osx_wrapper",
      objcopy_files = ":empty",
      static_runtime_libs = [":empty"],
      strip_files = ":empty",
      supports_param_files = 0,
    )

    cc_toolchain(
      name = "nix_linux_toolchain",
      all_files = ":empty",
      compiler_files = ":empty",
      cpu = "k8",
      dwp_files = ":empty",
      dynamic_runtime_libs = [":empty"],
      linker_files = ":empty",
      objcopy_files = ":empty",
      static_runtime_libs = [":empty"],
      strip_files = ":empty",
      supports_param_files = 0,
    )

    filegroup(
      name = "osx_wrapper",
      srcs = ["osx_cc_wrapper.sh"],
    )
  '';

  crosstoolFile = writeText "CROSSTOOL" (''
    major_version: "local"
    minor_version: ""
    default_target_cpu: "same_as_host"
    '' + lib.optionalString stdenv.isDarwin ''
    default_toolchain {
      cpu: "darwin"
      toolchain_identifier: "local_darwin"
    }
    toolchain {
      abi_version: "local"
      abi_libc_version: "local"
      builtin_sysroot: ""
      compiler: "compiler"
      host_system_name: "local"
      needsPic: true
      target_libc: "macosx"
      target_cpu: "darwin"
      target_system_name: "local"
      toolchain_identifier: "local_darwin"

      tool_path { name: "ar" path: "${cctools}/bin/libtool" }
      tool_path { name: "compat-ld" path: "${cctools}/bin/ld" }
      tool_path { name: "cpp" path: "${clang}/bin/cpp" }
      tool_path { name: "dwp" path: "${coreutils}/bin/false" }
      tool_path { name: "gcc" path: "osx_cc_wrapper.sh" }
      cxx_flag: "-std=c++0x"
      linker_flag: "-lstdc++"
      linker_flag: "-undefined"
      linker_flag: "dynamic_lookup"
      linker_flag: "-headerpad_max_install_names"
      # We know all files in `/nix/store` are immutable so it's safe to disable inclusion checks for them
      cxx_builtin_include_directory: "/nix/store"
      tool_path { name: "gcov" path: "${coreutils}/bin/false" }
      tool_path { name: "ld" path: "${cctools}/bin/ld" }
      tool_path { name: "nm" path: "${cctools}/bin/nm" }
      tool_path { name: "objcopy" path: "${binutils}/bin/objcopy" }
      objcopy_embed_flag: "-I"
      objcopy_embed_flag: "binary"
      tool_path { name: "objdump" path: "${binutils}/bin/objdump" }
      tool_path { name: "strip" path: "${cctools}/bin/strip" }

      # Anticipated future default.
      unfiltered_cxx_flag: "-no-canonical-prefixes"

      # Make C++ compilation deterministic. Use linkstamping instead of these
      # compiler symbols.
      unfiltered_cxx_flag: "-Wno-builtin-macro-redefined"
      unfiltered_cxx_flag: "-D__DATE__=\"redacted\""
      unfiltered_cxx_flag: "-D__TIMESTAMP__=\"redacted\""
      unfiltered_cxx_flag: "-D__TIME__=\"redacted\""

      # Security hardening on by default.
      # Conservative choice; -D_FORTIFY_SOURCE=2 may be unsafe in some cases.
      compiler_flag: "-D_FORTIFY_SOURCE=1"
      compiler_flag: "-fstack-protector"

      # Enable coloring even if there's no attached terminal. Bazel removes the
      # escape sequences if --nocolor is specified.
      compiler_flag: "-fcolor-diagnostics"

      # All warnings are enabled. Maybe enable -Werror as well?
      compiler_flag: "-Wall"
      # Enable a few more warnings that aren't part of -Wall.
      compiler_flag: "-Wthread-safety"
      compiler_flag: "-Wself-assign"

      # Keep stack frames for debugging, even in opt mode.
      compiler_flag: "-fno-omit-frame-pointer"

      # Anticipated future default.
      linker_flag: "-no-canonical-prefixes"

      compilation_mode_flags {
        mode: DBG
        # Enable debug symbols.
        compiler_flag: "-g"
      }
      compilation_mode_flags {
        mode: OPT
        # No debug symbols.
        # Maybe we should enable https://gcc.gnu.org/wiki/DebugFission for opt or even generally?
        # However, that can't happen here, as it requires special handling in Bazel.
        compiler_flag: "-g0"

        # Conservative choice for -O
        # -O3 can increase binary size and even slow down the resulting binaries.
        # Profile first and / or use FDO if you need better performance than this.
        compiler_flag: "-O2"

        # Disable assertions
        compiler_flag: "-DNDEBUG"

        # Removal of unused code and data at link time (can this increase binary size in some cases?).
        compiler_flag: "-ffunction-sections"
        compiler_flag: "-fdata-sections"
      }
      linking_mode_flags { mode: DYNAMIC }
    }
  '' + lib.optionalString stdenv.isLinux ''
    default_toolchain {
      cpu: "k8"
      toolchain_identifier: "local_linux"
    }

    toolchain {
      abi_version: "local"
      abi_libc_version: "local"
      builtin_sysroot: ""
      compiler: "compiler"
      host_system_name: "local"
      needsPic: true
      supports_gold_linker: false
      supports_incremental_linker: false
      supports_fission: false
      supports_interface_shared_objects: false
      supports_normalizing_ar: false
      supports_start_end_lib: false
      target_libc: "local"
      target_cpu: "k8"
      target_system_name: "local"
      toolchain_identifier: "local_linux"

      tool_path { name: "ar" path: "${binutils}/bin/ar" }
      tool_path { name: "compat-ld" path: "${binutils}/bin/ld" }
      tool_path { name: "cpp" path: "${stdenv.cc}/bin/cpp" }
      tool_path { name: "dwp" path: "${coreutils}/bin/false" }
      tool_path { name: "gcc" path: "${stdenv.cc}/bin/cc" }
      cxx_flag: "-std=c++0x"
      linker_flag: "-lstdc++"
      # We know all files in `/nix/store` are immutable so it's safe to disable inclusion checks for them
      cxx_builtin_include_directory: "/nix/store"
      tool_path { name: "gcov" path: "${coreutils}/bin/false" }

      # C(++) compiles invoke the compiler (as that is the one knowing where
      # to find libraries), but we provide LD so other rules can invoke the linker.
      tool_path { name: "ld" path: "${binutils}/bin/ld" }

      tool_path { name: "nm" path: "${binutils}/bin/nm" }
      tool_path { name: "objcopy" path: "${binutils}/bin/objcopy" }
      objcopy_embed_flag: "-I"
      objcopy_embed_flag: "binary"
      tool_path { name: "objdump" path: "${binutils}/bin/objdump" }
      tool_path { name: "strip" path: "${binutils}/bin/strip" }

      # Anticipated future default.
      unfiltered_cxx_flag: "-no-canonical-prefixes"
      unfiltered_cxx_flag: "-fno-canonical-system-headers"

      # Make C++ compilation deterministic. Use linkstamping instead of these
      # compiler symbols.
      unfiltered_cxx_flag: "-Wno-builtin-macro-redefined"
      unfiltered_cxx_flag: "-D__DATE__=\"redacted\""
      unfiltered_cxx_flag: "-D__TIMESTAMP__=\"redacted\""
      unfiltered_cxx_flag: "-D__TIME__=\"redacted\""

      # Security hardening on by default.
      # Conservative choice; -D_FORTIFY_SOURCE=2 may be unsafe in some cases.
      # We need to undef it before redefining it as some distributions now have
      # it enabled by default.
      compiler_flag: "-U_FORTIFY_SOURCE"
      compiler_flag: "-D_FORTIFY_SOURCE=1"
      compiler_flag: "-fstack-protector"
      linker_flag: "-Wl,-z,relro,-z,now"

      # Enable coloring even if there's no attached terminal. Bazel removes the
      # escape sequences if --nocolor is specified. This isn't supported by gcc
      # on Ubuntu 14.04.
      # compiler_flag: "-fcolor-diagnostics"

      # All warnings are enabled. Maybe enable -Werror as well?
      compiler_flag: "-Wall"
      # Enable a few more warnings that aren't part of -Wall.
      compiler_flag: "-Wunused-but-set-parameter"
      # But disable some that are problematic.
      compiler_flag: "-Wno-free-nonheap-object" # has false positives

      # Keep stack frames for debugging, even in opt mode.
      compiler_flag: "-fno-omit-frame-pointer"

      # Anticipated future default.
      linker_flag: "-no-canonical-prefixes"
      # Have gcc return the exit code from ld.
      linker_flag: "-pass-exit-codes"
      # Gold linker only? Can we enable this by default?
      # linker_flag: "-Wl,--warn-execstack"
      # linker_flag: "-Wl,--detect-odr-violations"

      compilation_mode_flags {
        mode: DBG
        # Enable debug symbols.
        compiler_flag: "-g"
      }
      compilation_mode_flags {
        mode: OPT

        # No debug symbols.
        # Maybe we should enable https://gcc.gnu.org/wiki/DebugFission for opt or
        # even generally? However, that can't happen here, as it requires special
        # handling in Bazel.
        compiler_flag: "-g0"

        # Conservative choice for -O
        # -O3 can increase binary size and even slow down the resulting binaries.
        # Profile first and / or use FDO if you need better performance than this.
        compiler_flag: "-O2"

        # Disable assertions
        compiler_flag: "-DNDEBUG"

        # Removal of unused code and data at link time (can this increase binary size in some cases?).
        compiler_flag: "-ffunction-sections"
        compiler_flag: "-fdata-sections"
        linker_flag: "-Wl,--gc-sections"
      }
      linking_mode_flags { mode: DYNAMIC }
    }
  '');

  osxCcWrapperFile = writeScript "osx_cc_wrapper.sh" (if stdenv.isDarwin then ''
    #!${customBash}/bin/bash
    #
    # Copyright 2015 The Bazel Authors. All rights reserved.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #    http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.
    #
    # OS X relpath is not really working. This is a wrapper script around gcc
    # to simulate relpath behavior.
    #
    # This wrapper uses install_name_tool to replace all paths in the binary
    # (bazel-out/.../path/to/original/library.so) by the paths relative to
    # the binary. It parses the command line to behave as rpath is supposed
    # to work.
    #
    # See https://blogs.oracle.com/dipol/entry/dynamic_libraries_rpath_and_mac
    # on how to set those paths for Mach-O binaries.
    #
    set -eu

    GCC="${clang}/bin/clang"
    INSTALL_NAME_TOOL="${cctools}/bin/install_name_tool"

    LIBS=
    LIB_DIRS=
    RPATHS=
    OUTPUT=
    # let parse the option list
    for i in "$@"; do
        if [[ "''${OUTPUT}" = "1" ]]; then
            OUTPUT=$i
        elif [[ "$i" =~ ^-l(.*)$ ]]; then
            LIBS="''${BASH_REMATCH[1]} $LIBS"
        elif [[ "$i" =~ ^-L(.*)$ ]]; then
            LIB_DIRS="''${BASH_REMATCH[1]} $LIB_DIRS"
        elif [[ "$i" =~ ^-Wl,-rpath,\@loader_path/(.*)$ ]]; then
            RPATHS="''${BASH_REMATCH[1]} ''${RPATHS}"
        elif [[ "$i" = "-o" ]]; then
            # output is coming
            OUTPUT=1
        fi
    done

    # Call gcc
    ''${GCC} "$@"

    function get_library_path() {
        for libdir in ''${LIB_DIRS}; do
            if [ -f ''${libdir}/lib$1.so ]; then
                echo "''${libdir}/lib$1.so"
            elif [ -f ''${libdir}/lib$1.dylib ]; then
                echo "''${libdir}/lib$1.dylib"
            fi
        done
    }

    # A convenient method to return the actual path even for non symlinks
    # and multi-level symlinks.
    function get_realpath() {
        local previous="$1"
        local next=$(readlink "''${previous}")
        while [ -n "''${next}" ]; do
            previous="''${next}"
            next=$(readlink "''${previous}")
        done
        echo "''${previous}"
    }

    # Get the path of a lib inside a tool
    function get_otool_path() {
        # the lib path is the path of the original lib relative to the workspace
        get_realpath $1 | sed 's|^.*/bazel-out/|bazel-out/|'
    }

    # Do replacements in the output
    for rpath in ''${RPATHS}; do
        for lib in ''${LIBS}; do
            unset libname
            if [ -f "$(dirname ''${OUTPUT})/''${rpath}/lib''${lib}.so" ]; then
                libname="lib''${lib}.so"
            elif [ -f "$(dirname ''${OUTPUT})/''${rpath}/lib''${lib}.dylib" ]; then
                libname="lib''${lib}.dylib"
            fi
            # ''${libname-} --> return $libname if defined, or undefined otherwise. This is to make
            # this set -e friendly
            if [[ -n "''${libname-}" ]]; then
                libpath=$(get_library_path ''${lib})
                if [ -n "''${libpath}" ]; then
                    ''${INSTALL_NAME_TOOL} -change $(get_otool_path "''${libpath}") \
                        "@loader_path/''${rpath}/''${libname}" "''${OUTPUT}"
                fi
            fi
        done
    done
  '' else "");

  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -F${CoreFoundation}/Library/Frameworks -F${CoreServices}/Library/Frameworks -F${Foundation}/Library/Frameworks"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${libcxx}/include/c++/v1"
  '' + ''
    mkdir nix
    cp ${buildFile} nix/BUILD
    cp ${crosstoolFile} nix/CROSSTOOL
    line=70
    for flag in $NIX_CFLAGS_COMPILE; do
      sed -i -e "$line a compiler_flag: \"$flag\"" nix/CROSSTOOL
      line=$((line + 1))
    done
    for flag in $NIX_LDFLAGS; do
      sed -i -e "$line a linker_flag: \"-Wl,$flag\"" nix/CROSSTOOL
      line=$((line + 1))
    done

    cp ${osxCcWrapperFile} nix/osx_cc_wrapper.sh
    find src/main/java/com/google/devtools -type f -print0 | while IFS="" read -r -d "" path; do
      substituteInPlace "$path" \
        --replace /bin/bash ${customBash}/bin/bash \
        --replace /usr/bin/env ${coreutils}/bin/env
    done
    # Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
    substituteInPlace scripts/bootstrap/compile.sh \
        --replace /bin/sh ${customBash}/bin/bash
    sed -i -e "361 a --crosstool_top=//nix:nix --host_crosstool_top=//nix:nix \\\\" scripts/bootstrap/compile.sh
    patchShebangs .
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i "s,/usr/bin/xcrun clang,clang $NIX_CFLAGS_COMPILE $NIX_LDFLAGS -framework CoreFoundation,g" \
      scripts/bootstrap/compile.sh \
      src/tools/xcode/realpath/BUILD \
      src/tools/xcode/stdredirect/BUILD \
      tools/osx/BUILD
  '';

  buildInputs = [
    jdk
  ];

  nativeBuildInputs = [
    gnused
    zip
    python
    unzip
    makeWrapper
    which
    customBash
  ] ++ lib.optionals (stdenv.isDarwin) [ cctools clang libcxx CoreFoundation CoreServices Foundation ];

  # If TMPDIR is in the unpack dir we run afoul of blaze's infinite symlink
  # detector (see com.google.devtools.build.lib.skyframe.FileFunction).
  # Change this to $(mktemp -d) as soon as we figure out why.

  buildPhase = ''
    export TMPDIR=/tmp
    ./compile.sh
    ./output/bazel --output_user_root=/tmp/.bazel build //scripts:bash_completion \
      --spawn_strategy=standalone \
      --genrule_strategy=standalone \
      --crosstool_top=//nix:nix --host_crosstool_top=//nix:nix
    cp bazel-bin/scripts/bazel-complete.bash output/
  '';

  # Build the CPP and Java examples to verify that Bazel works.

  doCheck = true;
  checkPhase = ''
    export TEST_TMPDIR=$(pwd)
    ./output/bazel test --test_output=errors \
        --crosstool_top=//nix:nix --host_crosstool_top=//nix:nix \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv output/bazel $out/bin
    wrapProgram "$out/bin/bazel" --set JAVA_HOME "${jdk}"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${customBash} ${gnused} ${coreutils}" > $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
