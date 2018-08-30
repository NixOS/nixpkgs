{ stdenv, fetchFromGitHub, fetchpatch, rustPlatform, clang, llvmPackages, rustfmt, writeScriptBin }:

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "0cqjr7qspjrfgqcp4nqxljmhhbqyijb2jpw3lajgjj48y6wrnw93";
  };

  cargoSha256 = "0b8v6c7q1abibzygrigldpd31lyd5ngmj4vq5d7zni96m20mm85w";

  libclang = llvmPackages.libclang.lib; #for substituteAll

  buildInputs = [ libclang ];

  propagatedBuildInputs = [ clang ]; # to populate NIX_CXXSTDLIB_COMPILE

  patches = [
    # https://github.com/rust-lang-nursery/rust-bindgen/pull/1376
    (fetchpatch {
      url = https://github.com/rust-lang-nursery/rust-bindgen/commit/c8b5406f08af82a92bf8faf852c21ba941d9c176.patch;
      sha256 = "16ibr2rplh0qz8rsq6gir45xlz5nasad4y8fprwhrb7ssv8wfkss";
    })
  ];

  configurePhase = ''
    export LIBCLANG_PATH="${libclang}/lib"
  '';

  postInstall = ''
    mv $out/bin/{bindgen,.bindgen-wrapped};
    substituteAll ${./wrapper.sh} $out/bin/bindgen
    chmod +x $out/bin/bindgen
  '';

  doCheck = false; # half the tests fail because our rustfmt is not nightly enough
  checkInputs =
    let fakeRustup = writeScriptBin "rustup" ''
      #!${stdenv.shell}
      shift
      shift
      exec "$@"
    '';
  in [
    rustfmt
    fakeRustup # the test suite insists in calling `rustup run nightly rustfmt`
    clang
  ];

  meta = with stdenv.lib; {
    description = "C and C++ binding generator";
    longDescription = ''
      Bindgen takes a c or c++ header file and turns them into
      rust ffi declarations.
      As with most compiler related software, this will only work
      inside a nix-shell with the required libraries as buildInputs.
    '';
    homepage = https://github.com/rust-lang-nursery/rust-bindgen;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.ralith ];
  };
}
