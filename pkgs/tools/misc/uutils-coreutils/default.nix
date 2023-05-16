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
<<<<<<< HEAD
  version = "0.0.20";
=======
  version = "0.0.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Xr+RcWvAHyMMaHhcd3ArGeRZzpL76v7fXiHUSSxgj10=";
=======
    sha256 = "sha256-r4IpmwZaRKzesvq7jAjCvfvZVmfcvwj23zMH3VnlC4I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-3hUEDE+Yup/+u/ACyAWXYTLerOqB/jtOzECdI540Ag0=";
=======
    hash = "sha256-ZbGLBjjAsdEhWK3/RS+yRI70xqV+5fzg76Y2Lip1m9A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ siraben ];
=======
    maintainers = with maintainers; [ siraben SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
