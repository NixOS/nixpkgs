{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, sphinx
, Security
, prefix ? "uutils-"
, buildMulticallBinary ? true
}:

stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    sha256 = "sha256-z5lDKJpFxXDCQq+0Da/63GGoUXacy5TSn+1gJiMvicc=";
  };

  postPatch = ''
    # can be removed after https://github.com/uutils/coreutils/pull/1815 is included
    substituteInPlace GNUmakefile \
      --replace uutils coreutils
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-x/nn2JNe8x+I0G2Vbr2PZAHCghwLBDhKAhkHPQFeL0M=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook sphinx ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  makeFlags = [
    "CARGO=${cargo}/bin/cargo"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
  ] ++ lib.optionals (prefix != null) [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ];

  # too many impure/platform-dependent tests
  doCheck = false;

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    maintainers = with maintainers; [ siraben SuperSandro2000 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
