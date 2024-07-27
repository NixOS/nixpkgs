{ pkgs ? import ../../.. {} }:

let
  libc = pkgs.stdenv.cc.libc;
  patchelf = pkgs.patchelf.overrideAttrs(previousAttrs: {
    NIX_CFLAGS_COMPILE = (previousAttrs.NIX_CFLAGS_COMPILE or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
    NIX_CFLAGS_LINK = (previousAttrs.NIX_CFLAGS_LINK or []) ++ [ "-static-libgcc" "-static-libstdc++" ];
  });
in with pkgs; rec {


  coreutilsMinimal = coreutils.override (args: {
    # We want coreutils without ACL/attr support.
    aclSupport = false;
    attrSupport = false;
    # Our tooling currently can't handle scripts in bin/, only ELFs and symlinks.
    singleBinary = "symlinks";
  });

  tarMinimal = gnutar.override { acl = null; };

  busyboxMinimal = busybox.override {
    useMusl = lib.meta.availableOn stdenv.hostPlatform musl;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_ASH y
      CONFIG_ASH_ECHO y
      CONFIG_ASH_TEST y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y
      CONFIG_MKDIR y
      CONFIG_TAR y
      CONFIG_UNXZ y
    '';
  };

  bootGCC = gcc.cc.override { enableLTO = false; };
  bootBinutils = binutils.bintools.override {
    withAllTargets = false;
    # Don't need two linkers, disable whatever's not primary/default.
    enableGold = false;
    # bootstrap is easier w/static
    enableShared = false;
  };

  build = callPackage ./stdenv-bootstrap-tools.nix {
    inherit bootBinutils coreutilsMinimal tarMinimal busyboxMinimal bootGCC libc patchelf;
  };

  bootstrapFiles = {
    # Make them their own store paths to test that busybox still works when the binary is named /nix/store/HASH-busybox
    busybox = runCommand "busybox" {} "cp ${build}/on-server/busybox $out";
    bootstrapTools = runCommand "bootstrap-tools.tar.xz" {} "cp ${build}/on-server/bootstrap-tools.tar.xz $out";
  };

  bootstrapTools =
    let extraAttrs = lib.optionalAttrs
      config.contentAddressedByDefault
      {
        __contentAddressed = true;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
      };
    in
    if (stdenv.hostPlatform.libc == "glibc") then
    import ./bootstrap-tools {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else if (stdenv.hostPlatform.libc == "musl") then
    import ./bootstrap-tools-musl {
      inherit (stdenv.buildPlatform) system; # Used to determine where to build
      inherit bootstrapFiles extraAttrs;
    }
    else throw "unsupported libc";

  test = derivation {
    name = "test-bootstrap-tools";
    inherit (stdenv.hostPlatform) system; # We cannot "cross test"
    builder = bootstrapFiles.busybox;
    args = [ "ash" "-e" "-c" "eval \"$buildCommand\"" ];

    buildCommand = ''
      export PATH=${bootstrapTools}/bin

      ls -l
      mkdir $out
      mkdir $out/bin
      sed --version
      find --version
      diff --version
      patch --version
      make --version
      awk --version
      grep --version
      gcc --version

    '' + lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
      rtld=$(echo ${bootstrapTools}/lib/${builtins.unsafeDiscardStringContext /* only basename */ (builtins.baseNameOf binutils.dynamicLinker)})
      libc_includes=${bootstrapTools}/include-glibc
    '' + lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
      rtld=$(echo ${bootstrapTools}/lib/ld-musl*.so.?)
      libc_includes=${bootstrapTools}/include-libc
    '' + ''
      # path to version-specific libraries, like libstdc++.so
      cxx_libs=$(echo ${bootstrapTools}/lib/gcc/*/*)
      export CPP="cpp -idirafter $libc_includes -B${bootstrapTools}"
      export  CC="gcc -idirafter $libc_includes -B${bootstrapTools} -Wl,-dynamic-linker,$rtld -Wl,-rpath,${bootstrapTools}/lib -Wl,-rpath,$cxx_libs"
      export CXX="g++ -idirafter $libc_includes -B${bootstrapTools} -Wl,-dynamic-linker,$rtld -Wl,-rpath,${bootstrapTools}/lib -Wl,-rpath,$cxx_libs"

      echo '#include <stdio.h>' >> foo.c
      echo '#include <limits.h>' >> foo.c
      echo 'int main() { printf("Hello World\\n"); return 0; }' >> foo.c
      $CC -o $out/bin/foo foo.c
      $out/bin/foo

      echo '#include <iostream>' >> bar.cc
      echo 'int main() { std::cout << "Hello World\\n"; }' >> bar.cc
      $CXX -v -o $out/bin/bar bar.cc
      $out/bin/bar

      tar xvf ${hello.src}
      cd hello-*
      ./configure --prefix=$out
      make
      make install
    '';
  };
}
