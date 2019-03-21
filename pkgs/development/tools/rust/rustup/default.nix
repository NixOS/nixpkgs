{ stdenv, lib, runCommand, patchelf
, fetchFromGitHub, rustPlatform
, pkgconfig, curl, Security }:

rustPlatform.buildRustPackage rec {
  name = "rustup-${version}";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rustup.rs";
    rev = version;
    sha256 = "1mf92z89wqqaj3cg2cqf6basvcz47krldmy8ianfkzp323fimqmn";
  };

  cargoSha256 = "0y7kbihdrpd35dw24qqqzmccvjdy6arka10p5rnv38d420f1bpzd";

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
    binlinks=(
      cargo rustc rustdoc rust-gdb rust-lldb rls rustfmt cargo-fmt
      cargo-clippy clippy-driver cargo-miri
    )
    for link in ''${binlinks[@]}; do
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
