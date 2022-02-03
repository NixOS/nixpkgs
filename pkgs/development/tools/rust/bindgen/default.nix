{ lib, fetchFromGitHub, rustPlatform, clang, rustfmt, writeTextFile
, runtimeShell
, bash
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-bindgen";
  version = "0.59.2";

  RUSTFLAGS = "--cap-lints warn"; # probably OK to remove after update

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bJYdyf5uZgWe7fQ80/3QsRV0qyExYn6P9UET3tzwPFs=";
  };

  cargoSha256 = "sha256-zhENlrqj611RkKDvpDtDFWc58wfQVamkJnpe2nvRieE=";

  #for substituteAll
  libclang = clang.cc.lib; # use the same version of clang for cxxincludes and libclang
  inherit bash;

  buildInputs = [ libclang ];

  preConfigure = ''
    export LIBCLANG_PATH="${lib.getLib libclang}/lib"
  '';

  postInstall = ''
    mv $out/bin/{bindgen,.bindgen-wrapped};
    export cincludes="$(< ${clang}/nix-support/cc-cflags) $(< ${clang}/nix-support/libc-cflags)"
    export cxxincludes="$(< ${clang}/nix-support/libcxx-cxxflags)"
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
      This version of bindgen is wrapped with the required compiler flags
      required to find the c and c++ standard libary of the input clang
      derivation.
    '';
    homepage = "https://github.com/rust-lang/rust-bindgen";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ johntitor ralith ];
  };
}
