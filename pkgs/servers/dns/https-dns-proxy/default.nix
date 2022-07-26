{ lib, stdenv, fetchFromGitHub, cmake, gtest, c-ares, curl, libev }:

stdenv.mkDerivation rec {
  pname = "https-dns-proxy";
  # there are no stable releases (yet?)
  version = "unstable-2021-03-29";

  src = fetchFromGitHub {
    owner = "aarond10";
    repo = "https_dns_proxy";
    rev = "bbd9ef272dcda3ead515871f594768af13192af7";
    sha256 = "sha256-r+IpDklI3vITK8ZlZvIFm3JdDe2r8DK2ND3n1a/ThrM=";
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

  meta = with lib; {
    description = "DNS to DNS over HTTPS (DoH) proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
