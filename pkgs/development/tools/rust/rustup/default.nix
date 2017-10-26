{ stdenv, lib, runCommand
, fetchFromGitHub, rustPlatform
, pkgconfig, curl, Security }:

rustPlatform.buildRustPackage rec {
  name = "rustup-${version}";
  version = "1.3.0";

  cargoSha256 = "1yd7k0jpx78p5bp6iyzgbyj7pjz8vyjg9g7fmf1bl60jsbdpgv3g";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustup.rs";
    rev = version;
    sha256 = "199jlqqidzak7nxmv2nzjzv7zfzy9z7hw6h8d8wf1rbfdwd9l6hs";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    curl
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "--features no-self-update" ];

  patches = lib.optionals stdenv.isLinux [
    (runCommand "0001-use-hardcoded-dynamic-linker.patch" { CC=stdenv.cc; } ''
       export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
       substituteAll ${./0001-use-hardcoded-dynamic-linker.patch} $out
    '')
  ];

  postInstall = ''
    pushd $out/bin
    mv rustup-init rustup
    for link in cargo rustc rustdoc rust-gdb rust-lldb; do
      ln -s rustup $link
    done
    popd

    # tries to create .rustup
    export HOME=$(mktemp -d)
    mkdir -p "$out/share/"{bash-completion/completions,fish/completions,zsh/site-functions}
    $out/bin/rustup completions bash > "$out/share/bash-completion/completions/rustup"
    $out/bin/rustup completions fish > "$out/share/fish/completions/rustup.fish"
    $out/bin/rustup completions zsh >  "$out/share/zsh/site-functions/_rustup"
  '';

  meta = with stdenv.lib; {
    description = "The Rust toolchain installer";
    homepage = https://www.rustup.rs/;
    license = licenses.mit;
    maintainer = [ maintainers.mic92 ];
  };
}
