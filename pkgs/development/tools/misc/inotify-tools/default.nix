{ lib, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.21.9.5";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "rvoicilas";
    rev = version;
    sha256 = "sha256-2eMYCFqecpY/yvhwl5+kvQ+pkdWzhX6Xsb+rcJEK37c=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/rvoicilas/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber pSub shamilton ];
    platforms = platforms.linux;
  };
}
