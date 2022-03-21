{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.3.3";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/xZxwEui8V5kyfGsmwRRkiyhj7lcJQaTmOjBihvdWg8=";
  };

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "https://github.com/twekkel/htpdate";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ julienmalka ];
  };
}
