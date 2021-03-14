{ stdenv, fetchFromGitHub, rustPlatform, cargo, cmake, sphinx, lib, prefix ? "uutils-"
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "uutils-coreutils";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    sha256 = "sha256-z5lDKJpFxXDCQq+0Da/63GGoUXacy5TSn+1gJiMvicc=";
  };

  # too many impure/platform-dependent tests
  doCheck = false;

  cargoSha256 = "sha256-x/nn2JNe8x+I0G2Vbr2PZAHCghwLBDhKAhkHPQFeL0M=";

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
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
