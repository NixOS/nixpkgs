{ lib, fetchFromGitHub, rustPlatform, clang, llvmPackages, rustfmt, writeScriptBin
, runtimeShell
, bash
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen";
  version = "0.55.1";

  RUSTFLAGS = "--cap-lints warn"; # probably OK to remove after update

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbc78zrhda4adza88g05sy04chixqay2ylgdjgmf13h607hp3kn";
  };

  cargoSha256 = "1dv1ywdy701bnc2jv5jq0hnpal1snlizaj9w6k1wxyrp9szjd48w";

  #for substituteAll
  libclang = llvmPackages.libclang.lib;
  inherit bash;

  buildInputs = [ libclang ];

  propagatedBuildInputs = [ clang ]; # to populate NIX_CXXSTDLIB_COMPILE

  configurePhase = ''
    export LIBCLANG_PATH="${libclang}/lib"
  '';

  postInstall = ''
    mv $out/bin/{bindgen,.bindgen-wrapped};
    substituteAll ${./wrapper.sh} $out/bin/bindgen
    chmod +x $out/bin/bindgen
  '';

  doCheck = true;
  checkInputs =
    let fakeRustup = writeScriptBin "rustup" ''
      #!${runtimeShell}
      shift
      shift
      exec "$@"
    '';
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
