{ rust-bindgen-unwrapped, zlib, bash, runCommand, runCommandCC }:
let
  clang = rust-bindgen-unwrapped.clang;
  self = runCommand "rust-bindgen-${rust-bindgen-unwrapped.version}"
    {
      #for substituteAll
      inherit bash;
      unwrapped = rust-bindgen-unwrapped;
      libclang = clang.cc.lib;
      meta = rust-bindgen-unwrapped.meta // {
        longDescription = rust-bindgen-unwrapped.meta.longDescription + ''
          This version of bindgen is wrapped with the required compiler flags
          required to find the c and c++ standard libary, as well as the libraries
          specified in the buildInputs of your derivation.
        '';
      };
      passthru.tests = {
        simple-c = runCommandCC "simple-c-bindgen-tests" { } ''
          echo '#include <stdlib.h>' > a.c
          ${self}/bin/bindgen a.c --whitelist-function atoi | tee output
          grep atoi output
          touch $out
        '';
        simple-cpp = runCommandCC "simple-cpp-bindgen-tests" { } ''
          echo '#include <cmath>' > a.cpp
          ${self}/bin/bindgen a.cpp --whitelist-function erf -- -xc++ | tee output
          grep erf output
          touch $out
        '';
        with-lib = runCommandCC "zlib-bindgen-tests" { buildInputs = [ zlib ]; } ''
          echo '#include <zlib.h>' > a.c
          ${self}/bin/bindgen a.c --whitelist-function compress | tee output
          grep compress output
          touch $out
        '';
      };
    } ''
    mkdir -p $out/bin
    export cincludes="$(< ${clang}/nix-support/cc-cflags) $(< ${clang}/nix-support/libc-cflags)"
    export cxxincludes="$(< ${clang}/nix-support/libcxx-cxxflags)"
    substituteAll ${./wrapper.sh} $out/bin/bindgen
    chmod +x $out/bin/bindgen
  '';
in
self
