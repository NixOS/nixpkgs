{ stdenv, fetchFromGitHub, rustPlatform, clang, llvmPackages, rustfmt, writeScriptBin }:

rustPlatform.buildRustPackage rec {
  name = "rust-bindgen-${version}";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rust-bindgen";
    rev = "v${version}";
    sha256 = "0d7jqgi3aadwqcxiaz7axsq9h6n2i42yd3q0p1hc5l0kcdwwbj5k";
  };

  cargoSha256 = "1rjyazhnk9xihqw1qzkkcrab627lqbj789g5d5nb8bn2hkbdx5d6";

  libclang = llvmPackages.libclang.lib; #for substituteAll

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
