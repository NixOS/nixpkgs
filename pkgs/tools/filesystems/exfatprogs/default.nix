{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, file }:

stdenv.mkDerivation rec {
  pname = "exfatprogs";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-xNspLbm7v4nj82Y4gYqWEBU7cVlFBh3rnqhQ8CXEqrw=";
=======
    sha256 = "sha256-8M+016RnwZt0BrRaCTytpl7o+8MJAkS5CG/GvNAJRgk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config autoreconfHook file ];

  meta = with lib; {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zane ];
    platforms = platforms.linux;
  };
}
