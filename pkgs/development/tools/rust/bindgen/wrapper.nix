/*
bindgen uses the raw libclang and therefore cannot find any headers.  those
are provided to clang by cc-wrapper.  In this file, we implement such a wrapper
for bindgen.

To prevent code duplication and have a more or less
cc-wrapper-internals-agnostic wrapper, we use the trick of wrapping a fake
clang with the real cc-wrapper and then harvest the arguments. More precisely:

* upper-wrapper.py splits command line arguments between those destined to
bindgen and this destined to clang. It stores the arguments for bindgen in an
environment variable, and execs the fake cc-wrapped clang with the arguments
destined to clang only. (plus a fake file and -c to prevent warnings)
* cc-wrapper does its job and adds most include flags and then execs the fake
clang which is in fact wrapper.py.
* wrapper.py reads the bindgen flags, removes -c and other fake flags we added
before and execs the real bindgen.

This nearly works, but we still have to add include flags for
* clang/lib/clang/${version}/include for things like stddef.h
* libstdc++
The former is added by wrapper.py and the latter is added by propagating libstdcxxHook
like clang-wrapped does.
*/
{ stdenv, ccWrapperFun, libstdcxxHook, clangStdenv, python3, rust-bindgen-unwrapped }:
let
clang = clangStdenv.cc.cc;
clangVersion = (builtins.parseDrvName clang.name).version;
# inner wrapper
fakeClang = stdenv.mkDerivation {
  name = "rust-bindgen-wrapper";
  buildInputs = [ python3 ];
  src = ./wrapper.py;
  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    substitute $src $out/bin/clang \
      --subst-var-by bindgen ${rust-bindgen-unwrapped}/bin/bindgen \
      --subst-var-by internal_includes ${clang}/lib/clang/${clangVersion}/include
    chmod +x $out/bin/clang
  '';
  /* attributes for ccWrapperFun */
  isClang = true;
  inherit (clang) gcc;
};
# copied from pkgs/development/compilers/llvm/5/default.nix, definition of libStdcxxClang
wrappedFakeClang = ccWrapperFun {
      cc = fakeClang;
      inherit (stdenv.cc) bintools libc nativeTools nativeLibc;
    };
in
stdenv.mkDerivation {
  name = "rust-bindgen-upper-wrapper";
  buildInputs = [ python3 ];
  propagatedBuildInputs = [
    libstdcxxHook # to have bindgen find libstd++
  ];
  src = ./upper-wrapper.py;
  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    substitute $src $out/bin/bindgen --subst-var-by clang ${wrappedFakeClang}/bin/clang
    chmod +x $out/bin/bindgen
  '';
  inherit (rust-bindgen-unwrapped) meta;
}
