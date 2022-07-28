{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.3.5";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L3CKBgGk9R8qJFWOS98Tm1j/s/5t6+/Vt2EcZ+or0Ng=";
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
