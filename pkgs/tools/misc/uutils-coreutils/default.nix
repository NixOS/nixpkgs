{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, unstableGitUpdater
, rustPlatform
, cargo
, Security
, libiconv
, withDocs ? true
, sphinx
, withPrefix ? false
, buildMulticallBinary ? true
}:

let
  prefix = "uutils-";
in
stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    sha256 = "sha256-dnswE/DU2jCfxWW10Ctjw8woktwWZqyd3E9IuKkle1M=";
  };

  postPatch = ''
    # don't enforce the building of the man page
    substituteInPlace GNUmakefile \
      --replace 'install: build' 'install:'
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-92BHPSVIPZLn399AcaJJjRq2WkxzDm8knKN3FIdAxAA=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ]
    ++ lib.optional withDocs sphinx;

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  makeFlags = [
    "CARGO=${cargo}/bin/cargo"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
  ] ++ lib.optionals withPrefix [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ]
  ++ lib.optionals (!withDocs) [ "build-coreutils" "build-pkgs" ];

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
