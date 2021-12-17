{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, sphinx
, Security
, libiconv
, prefix ? "uutils-"
, buildMulticallBinary ? true
}:

stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    sha256 = "0hx5ypy58d182gxpgs0dxcw03pdgvrcikbhczg6yqpdjjh7163as";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256:1ynw97dr40yg18jaqgvz3shs0s0j6pvvlkrbka2ganiv8c9fvbyw";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook sphinx ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

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
