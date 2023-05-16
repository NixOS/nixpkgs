<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub }:
=======
{lib, stdenv, fetchFromGitHub, pkg-config, ncurses, libnl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "userhosts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "figiel";
    repo = "hosts";
    rev = "v${version}";
    hash = "sha256-9uF0fYl4Zz/Ia2UKx7CBi8ZU8jfWoBfy2QSgTSwXo5A";
  };

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A libc wrapper providing per-user hosts file";
    homepage = "https://github.com/figiel/hosts";
    maintainers = [ maintainers.bobvanderlinden ];
    license = licenses.cc0;
    platforms = platforms.linux;
  };
}
