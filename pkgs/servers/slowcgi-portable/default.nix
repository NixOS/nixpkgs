{ stdenv, lib, fetchFromGitHub, libevent, libbsd, pkg-config }:
stdenv.mkDerivation rec {
  pname = "slowcgi-portable";
  version = "6.5+git20210716.0fce043";

  src = fetchFromGitHub {
    owner = "adaugherity";
    repo = "slowcgi-portable";
    rev = "0fce04362f807473870a6f700ede6bcaf15818ea";
    hash = "sha256-JYWY+J28NgEMtrobM0sSn83BpxCXFXW+UpuBK+5dSIw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libevent
    libbsd
  ];

  makeFlags = "prefix=$(out) sbindir=$(out)/bin";

  meta = with lib; {
    description = "A FastCGI to CGI wrapper, ported from OpenBSD";
    homepage = "https://github.com/adaugherity/slowcgi-portable";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ piperswe ];
  };
}
