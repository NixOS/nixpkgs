{ lib, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.20.11.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "rvoicilas";
    rev = version;
    sha256 = "1m8avqccrhm38krlhp88a7v949f3hrzx060bbrr5dp5qw2nmw9j2";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/rvoicilas/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ marcweber pSub shamilton ];
    platforms = platforms.linux;
  };
}
