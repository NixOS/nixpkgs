{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
<<<<<<< HEAD
  version = "2.11.0";
=======
  version = "2.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-WNSpV3KhALzl35R1hR0QBzm8atdnbfsB5xh3h4MZBqA=";
=======
    sha256 = "sha256-PgG9ElIbJCr607ZrQcmuUcOwr8FSQW+cDytvaNLALnQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gnutls libite libconfuse ];

<<<<<<< HEAD
  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/projects/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
