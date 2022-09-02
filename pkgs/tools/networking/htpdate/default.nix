{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.3.6";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0NLlBNYTJ+hmQLH/UYwIOIbq3G1sDo/A03xFHsXdzig=";
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
