{ rust-bindgen-unwrapped, bash, runCommand }:
let
  clang = rust-bindgen-unwrapped.clang;
in
runCommand "rust-bindgen-${rust-bindgen-unwrapped.version}"
{
  #for substituteAll
  inherit bash;
  unwrapped = rust-bindgen-unwrapped;
  libclang = clang.cc.lib;
} ''
  mkdir -p $out/bin
  export cincludes="$(< ${clang}/nix-support/cc-cflags) $(< ${clang}/nix-support/libc-cflags)"
  export cxxincludes="$(< ${clang}/nix-support/libcxx-cxxflags)"
  substituteAll ${./wrapper.sh} $out/bin/bindgen
  chmod +x $out/bin/bindgen
''

