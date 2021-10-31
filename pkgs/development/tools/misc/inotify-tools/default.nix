{ lib, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.21.9.6";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "rvoicilas";
    rev = version;
    sha256 = "sha256-oKcVmF39N43g8O1S+xwUhVJryFcW+ZUteyoe3fUkRH8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/rvoicilas/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber pSub shamilton ];
    platforms = platforms.linux;
  };
}
