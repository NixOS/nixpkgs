{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libnfc, xz }:

stdenv.mkDerivation rec {
  pname = "mfoc-hardnested";
  version = "unstable-2021-08-14";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = pname;
    rev = "2c25bf05a0b13827b9d06382c5d384b2e5c88238";
    hash = "sha256-fhfevQCw0E5TorHx61Vltpmv7DAjgH73i27O7aBKxz4=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libnfc xz ];

  meta = with lib; {
    description = "A fork of mfoc integrating hardnested code from the proxmark";
    license = licenses.gpl2;
    homepage = "https://github.com/nfc-tools/mfoc-hardnested";
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.unix;
    broken = (stdenv.isDarwin && stdenv.isAarch64); # Undefined symbols "_memalign" referenced
  };
}
