{ stdenv, fetchFromGitHub, rustPlatform, cargo, cmake, sphinx, lib, prefix ? "uutils-"
, Security
}:

let
  pname = "uutils-coreutils";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    sha256 = "0rlvwmyk8c597x1krvlyyqhk1m7g2pz2rkwsam8yj3ksb670g53j";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  # too many impure/platform-dependent tests
  doCheck = false;

  cargoSha256 = "102gx1fm37zrvi1jmbv2fj9ds7j7s00aqa9880pja3sh6ykqk0rb";

  makeFlags =
    [ "CARGO=${cargo}/bin/cargo" "PREFIX=$(out)" "PROFILE=release" "INSTALLDIR_MAN=$(out)/share/man/man1" ]
    ++ lib.optional (prefix != null) [ "PROG_PREFIX=${prefix}" ];

  nativeBuildInputs = [ cmake cargo sphinx ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  # empty {build,install}Phase to use defaults of `stdenv.mkDerivation` rather than rust defaults
  buildPhase = "";
  installPhase = "";

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
