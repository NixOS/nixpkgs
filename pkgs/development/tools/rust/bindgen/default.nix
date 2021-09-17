{ lib, fetchFromGitHub, rustPlatform, clang, llvmPackages_latest, rustfmt, writeTextFile
, runtimeShell
, bash
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen";
  version = "0.59.1";

  RUSTFLAGS = "--cap-lints warn"; # probably OK to remove after update

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nCww9sr6kF7nCQeIGtOXddxD3dR/SJ0rqAc+RlZnUkQ=";
  };

  cargoSha256 = "sha256-3EXYC/mwzVxo/ginvF1WFtS7ABE/ybyuKb58uMqfTDs=";

  #for substituteAll
  libclang = llvmPackages_latest.libclang.lib;
  inherit bash;

  buildInputs = [ libclang ];

  propagatedBuildInputs = [ clang ]; # to populate NIX_CXXSTDLIB_COMPILE

  configurePhase = ''
    export LIBCLANG_PATH="${libclang.lib}/lib"
  '';

  postInstall = ''
    mv $out/bin/{bindgen,.bindgen-wrapped};
    substituteAll ${./wrapper.sh} $out/bin/bindgen
    chmod +x $out/bin/bindgen
  '';

  doCheck = true;
  checkInputs =
    let fakeRustup = writeTextFile {
      name = "fake-rustup";
      executable = true;
      destination = "/bin/rustup";
      text = ''
        #!${runtimeShell}
        shift
        shift
        exec "$@"
      '';
    };
  in [
    rustfmt
    fakeRustup # the test suite insists in calling `rustup run nightly rustfmt`
    clang
  ];
  preCheck = ''
    # for the ci folder, notably
    patchShebangs .
  '';

  meta = with lib; {
    description = "Automatically generates Rust FFI bindings to C (and some C++) libraries";
    longDescription = ''
      Bindgen takes a c or c++ header file and turns them into
      rust ffi declarations.
      As with most compiler related software, this will only work
      inside a nix-shell with the required libraries as buildInputs.
    '';
    homepage = "https://github.com/rust-lang/rust-bindgen";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ johntitor ralith ];
  };
}
