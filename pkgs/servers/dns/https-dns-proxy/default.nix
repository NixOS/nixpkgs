{ stdenv, fetchFromGitHub, cmake, gtest, c-ares, curl, libev }:

stdenv.mkDerivation rec {
  pname = "https-dns-proxy";
  # there are no stable releases (yet?)
  version = "unstable-20200419";

  src = fetchFromGitHub {
    owner = "aarond10";
    repo = "https_dns_proxy";
    rev = "79fc7b085e3b1ad64c8332f7115dfe2bf5f1f3e4";
    sha256 = "1cdfswfjby4alp6gy7yyjm76kfyclh5ax0zadnqs2pyigg9plh0b";
  };

  nativeBuildInputs = [ cmake gtest ];

  buildInputs = [ c-ares curl libev ];

  installPhase = ''
    install -Dm555 -t $out/bin https_dns_proxy
    install -Dm444 -t $out/share/doc/${pname} ../{LICENSE,README}.*
  '';

  # upstream wants to add tests and the gtest framework is in place, so be ready
  # for when that happens despite there being none as of right now
  doCheck = true;

  meta = with stdenv.lib; {
    description = "DNS to DNS over HTTPS (DoH) proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
