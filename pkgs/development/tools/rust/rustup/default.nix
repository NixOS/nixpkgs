{ stdenv, lib, runCommand, patchelf
, fetchFromGitHub, rustPlatform
, pkgconfig, curl, Security }:

rustPlatform.buildRustPackage rec {
  name = "rustup-${version}";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustup.rs";
    rev = version;
    sha256 = "1z9358y01jlpx7xlj56ba1d05dxb98j1wd2agrlhwmidmwp8qbz5";
  };

  cargoSha256 = "0syp53s285ixshp6yswly0mwkcl0y2ddj5hc110irqsrvwgss32r";

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

  doCheck = !stdenv.isAarch64;

  postInstall = ''
    pushd $out/bin
    mv rustup-init rustup
    for link in cargo rustc rustdoc rust-gdb rust-lldb rls rustfmt cargo-fmt cargo-clippy; do
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
