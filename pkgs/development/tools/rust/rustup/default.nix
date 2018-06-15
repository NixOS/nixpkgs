{ stdenv, lib, runCommand, patchelf
, fetchFromGitHub, rustPlatform
, pkgconfig, curl, Security }:

rustPlatform.buildRustPackage rec {
  name = "rustup-${version}";
  version = "1.11.0";

  cargoSha256 = "1r9mnj3x9sn16hi1r09gl5q0cnsa2g6kbjw2g115858i2a9k6hkr";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustup.rs";
    rev = version;
    sha256 = "05rbgkz4fk6c1x6bpmpx108bg2qcrf6vv3yfz378s7bmr3l319iz";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    curl
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "--features no-self-update" ];

  patches = lib.optionals stdenv.isLinux [
    (runCommand "0001-dynamically-patchelf-binaries.patch" { CC=stdenv.cc; patchelf = patchelf; } ''
       export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
       substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
         --subst-var patchelf \
         --subst-var dynamicLinker
    '')
  ];

  postInstall = ''
    pushd $out/bin
    mv rustup-init rustup
    for link in cargo rustc rustdoc rust-gdb rust-lldb rls rustfmt cargo-fmt; do
      ln -s rustup $link
    done
    popd

    # tries to create .rustup
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/rustup completions bash > "$out/share/bash-completion/completions/rustup"
    $out/bin/rustup completions fish > "$out/share/fish/vendor_completions.d/rustup.fish"
    $out/bin/rustup completions zsh >  "$out/share/zsh/site-functions/_rustup"
  '';

  meta = with stdenv.lib; {
    description = "The Rust toolchain installer";
    homepage = https://www.rustup.rs/;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mic92 ];
  };
}
