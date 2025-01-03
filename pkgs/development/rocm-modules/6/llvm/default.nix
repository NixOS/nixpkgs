{
  # stdenv FIXME: Try changing back to this with a new ROCm release https://github.com/NixOS/nixpkgs/issues/271943
  stdenv,
  lib,
  gcc13Stdenv,
  callPackage,
  fetchFromGitHub,
  rocmUpdateScript,
  wrapBintoolsWith,
  overrideCC,
  wrapCCWith,
  wrapCC,
  fetchpatch,

  pkg-config,
  cmake,
  ninja,
  git,
  makeBinaryWrapper,
  python3Packages,
  doxygen,
  sphinx,
  lit,
  libxml2,
  libxcrypt,
  libffi,
  mpfr,
  libedit,
  ncurses,
  zlib,
  zstd,

  rocm-device-libs,
  rocm-runtime,
  rocm-thunk,
  clr,
  buildTests ? false,
  buildMan ? false,
  buildDocs ? false,

  ccache,
}:

rec {
  llvm =
    let
      targetProjects = [ "llvm" "clang" "lld" "clang-tools-extra" "compiler-rt" ];
      # targetRuntimes = [ "libc" "libunwind" "libcxxabi" "libcxx" "compiler-rt" ];
      targetRuntimes = [ ];
      llvmTargetsToBuild = [ "X86" "AMDGPU" ];
      # stdenv = gcc13Stdenv;
    in
      stdenv.mkDerivation (finalAttrs: {
        pname = "rocm-llvm";
        version = "6.0.2";

        outputs =
          [
            "out"
          ]
          ++ lib.optionals buildDocs [
            "doc"
          ]
          ++ lib.optionals buildMan [
            "man"
            "info" # Avoid `attribute 'info' missing` when using with wrapCC
          ];

        patches = [
          # ./clang-bodge-ignore-systemwide-incls.diff
          # ./clang-at-least-16-LLVMgold-path.patch
          # ./clang-log-jobs.diff
          # For LLVM 17 only!
          (fetchpatch {
            name = "fix-fzero-call-used-regs.patch";
            url = "https://github.com/llvm/llvm-project/commit/f800c1f3b207e7bcdc8b4c7192928d9a078242a0.patch";
            # stripLen = 1;
            hash = "sha256-xwuHEKzAO88pcFN2/PzKGwz7gD1dAcfq2WShZ7TwDVo=";
          })
        ];

        src = fetchFromGitHub {
          owner = "ROCm";
          repo = "llvm-project";
          rev = "rocm-${finalAttrs.version}";
          hash = "sha256-uGxalrwMNCOSqSFVrYUBi3ijkMEFFTrzFImmvZKQf6I=";
        };

        nativeBuildInputs =
          [
            pkg-config
            cmake
            ninja
            git
            makeBinaryWrapper
            (python3Packages.python.withPackages (p: [ p.setuptools ]))

            ccache
          ]
          ++ lib.optionals (buildDocs || buildMan) [
            doxygen
            sphinx
            python3Packages.recommonmark
          ]
          ++ lib.optionals (buildTests) [
            lit
          ];

        buildInputs = [
          libxml2
          libxcrypt
          libffi
          mpfr
        ];

        propagatedBuildInputs = [
          libedit
          ncurses
          zlib
          zstd
        ];

        env = {
          CMAKE_C_COMPILER_LAUNCHER = "${ccache}/bin/ccache";
          CMAKE_CXX_COMPILER_LAUNCHER = "${ccache}/bin/ccache";
          CCACHE_DIR = "/nix/var/cache/ccache";
          CCACHE_COMPRESS = "1";
          # CCACHE_NOCOMPRESS = "true";
          CCACHE_UMASK = "007";
        };

        cmakeFlags =
          [
            "-DLLVM_TARGETS_TO_BUILD=${builtins.concatStringsSep ";" llvmTargetsToBuild}"
            "-DLLVM_ENABLE_PROJECTS=${lib.concatStringsSep ";" targetProjects}"
            "-DLLVM_ENABLE_RUNTIMES=${lib.concatStringsSep ";" targetRuntimes}"
            # (lib.cmakeBool "COMPILER_RT_STANDALONE_BUILD" true)
            # (lib.cmakeBool "LIBC_ENABLE_USE_BY_CLANG" false)
            (lib.cmakeFeature "LLVM_BINUTILS_INCDIR" "${stdenv.cc.bintools.bintools.plugin-api-header}/include")
            # (lib.cmakeBool "LLVM_BUILD_EXTERNAL_COMPILER_RT" false)
            (lib.cmakeBool "LLVM_INCLUDE_TESTS" buildTests)
            (lib.cmakeBool "LLVM_BUILD_TESTS" buildTests)
            # (lib.cmakeBool "LLVM_LIBC_FULL_BUILD" true)
            # (lib.cmakeFeature "DEFAULT_SYSROOT" "${stdenv.cc.libc}")
            # (lib.cmakeFeature "GCC_INSTALL_PREFIX" "${bootstrapSysroot}")
            # (lib.cmakeFeature "DEFAULT_SYSROOT" "${placeholder "out"}")
            # (lib.cmakeBool "COMPILER_RT_BUILD_XRAY" false)
            # (lib.cmakeFeature "DEFAULT_SYSROOT" "${stdenv.cc.targetPrefix}")
            # (lib.cmakeFeature "CLANG_CONFIG_FILE_SYSTEM_DIR" "${placeholder "out"}/share/llvm-rocm6/config")
          ]
          ++ [
            "-DLLVM_INSTALL_UTILS=ON"
            "-DLLVM_INSTALL_GTEST=OFF"
          ]
          ++ lib.optionals (buildDocs || buildMan) [
            "-DLLVM_INCLUDE_DOCS=ON"
            "-DLLVM_BUILD_DOCS=ON"
            # "-DLLVM_ENABLE_DOXYGEN=ON" Way too slow, only uses one core
            "-DLLVM_ENABLE_SPHINX=ON"
            "-DSPHINX_OUTPUT_HTML=ON"
            "-DSPHINX_OUTPUT_MAN=ON"
            "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
          ]
          ++ lib.optionals buildTests [
            "-DLLVM_EXTERNAL_LIT=${lit}/bin/.lit-wrapped"
          ];

        postPatch =
          ''
            cd llvm
            patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
          '';

        doCheck = buildTests;

        # postInstall =
        # let
        #   gcc = stdenv.cc.cc;
        #   libc = stdenv.cc.libc;
        #   libc_dev = lib.getDev libc;
        #   libc_lib = lib.getLib libc;
        #   hostPlatform = stdenv.hostPlatform;
        #   targetPlatform = stdenv.targetPlatform;
        # in
        # ''
        #   # This is the config for the final compiler
        #   mkdir -p $out/share/llvm-rocm6/config
        #   gcc_ver=$(basename ${gcc}/lib/gcc/${targetPlatform.config}/*)
        #   pushd $out/share/llvm-rocm6/config
        #     # General
        #     echo "--gcc-toolchain=${gcc}" | tee clang.cfg
        #
        #     # libc
        #     echo "-B${libc_lib}/lib" | tee -a clang.cfg
        #     echo "-B${gcc}/lib/gcc/${targetPlatform.config}/$gcc_ver" | tee -a clang.cfg
        #     echo "-idirafter ${libc_dev}/include" | tee -a clang.cfg
        #     echo "-L${gcc}/lib" | tee -a clang.cfg
        #     echo "-L${gcc.libgcc}/lib" | tee -a clang.cfg
        #
        #     # libc++
        #     for dir in ${gcc}/include/c++/*; do
        #       echo "-isystem $dir" | tee -a clang.cfg
        #     done
        #     for dir in ${gcc}/include/c++/*/${hostPlatform.config}*; do
        #       echo "-isystem $dir" | tee -a clang.cfg
        #     done
        #     # echo "-isystem $out/include/c++/v1" | tee -a clang.cfg
        #     echo \
        #       "${lib.optionalString profilableStdenv "-gz -gz -fno-omit-frame-pointer -momit-leaf-frame-pointer"}" \
        #       | tee -a clang.cfg
        #     # echo "" | tee clang.cfg
        #
        #     cp clang.cfg clang++.cfg
        #     echo "--stdlib=libstdc++" | tee -a clang++.cfg
        #
        #     cp clang.cfg clang-cpp.cfg
        #     cp clang.cfg clang-cl.cfg
        #     cp clang.cfg flang.cfg
        #     cp clang.cfg clang-dxc.cfg
        #   popd
        #
        #   $out/bin/clang --version
        #   $out/bin/clang -print-resource-dir
        #
        #   echo '#include <iostream>' >> test.cpp
        #   echo '#include <cmath>' >> test.cpp
        #   echo 'int main() { std::cout << "Hello World!" << std::max(2, 3); }' >> test.cpp
        #   echo "Compiling as C++"
        #   $out/bin/clang++ -v -std=c++17 -o test test.cpp
        # ''
        # + lib.optionalString buildMan ''
        #   mkdir -p $info
        # '';

        passthru = {
          updateScript = rocmUpdateScript {
            name = finalAttrs.pname;
            owner = finalAttrs.src.owner;
            repo = finalAttrs.src.repo;
          };
          isClang = true;
          isLLVM = true;
        };

        meta = with lib; {
          description = "ROCm fork of the LLVM compiler infrastructure";
          homepage = "https://github.com/ROCm/llvm-project";
          license = with licenses; [ ncsa ];
          maintainers =
            with maintainers;
            [
              acowley
              lovesegfault
            ]
            ++ teams.rocm.members;
          platforms = platforms.linux;
          broken = versionAtLeast finalAttrs.version "7.0.0";
        };
      });

  clang = wrapCCWith ({
    name = "rocm-clang";
    cc = llvm;
    # If C compilation breaks, check if cc-wrapper is adding some flags to
    # `libcxx-cxxflags` that would cause problems for the C compiler.
    extraBuildCommands = ''
      # HIP will be invoked through C compiler (`clang`) even though it needs C++ headers
      cat $out/nix-support/libcxx-cxxflags | tee -a $out/nix-support/cc-cflags

      # Hardening is basically broken on HIP
      echo "" | tee $out/nix-support/add-hardening.sh
    '';
  });

  openmp = llvm;

  clang-tools-extra = llvm;
}
