{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dnsmap-${version}";
  version = "0.30+git20170911";

  src = fetchFromGitHub {
    owner = "makefu";
    repo = "dnsmap";
    rev = "d2f89e0e97969961d53e2222839cdd079d7b4ed2";
    sha256 = "16snf573k2f5r9f0skkbpclbj9hzyh8f0ry9crd2qr2snc7wxikx";
  };

  makeFlags = [ "DESTDIR=$(out)" "BINDIR=/bin" ];

  meta = with stdenv.lib; {
    description = "Passive DNS network mapper a.k.a. subdomains bruteforcer";
    license = licenses.gpl2;
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
