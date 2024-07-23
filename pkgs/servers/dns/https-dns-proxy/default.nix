{ lib, stdenv, fetchFromGitHub, cmake, gtest, c-ares, curlHTTP3, libev }:

let
  curl' = curlHTTP3;
in
stdenv.mkDerivation rec {
  pname = "https-dns-proxy";
  # there are no stable releases (yet?)
  version = "unstable-2023-11-20";

  src = fetchFromGitHub {
    owner = "aarond10";
    repo = "https_dns_proxy";
    rev = "489c57efd46983e688579974a2ab7aeaa7df8d83";
    hash = "sha256-5sbBMQ+a95UOm9laWANhPx+KaXskisXlytc5KK5fHiY=";
  };

  postPatch = ''
    substituteInPlace https_dns_proxy.service.in \
      --replace "\''${CMAKE_INSTALL_PREFIX}/" ""
    substituteInPlace munin/https_dns_proxy.plugin \
      --replace '--unit https_dns_proxy.service' '--unit https-dns-proxy.service'
  '';

  nativeBuildInputs = [ cmake gtest ];

  buildInputs = [ c-ares curl' libev ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} ../{LICENSE,*.md}
    install -Dm444 -t $out/share/${pname}/munin ../munin/*
    # the systemd service definition is garbage, and we use our own with NixOS
    mv $out/lib/systemd $out/share/${pname}
    rmdir $out/lib
  '';

  # upstream wants to add tests and the gtest framework is in place, so be ready
  # for when that happens despite there being none as of right now
  doCheck = true;

  meta = with lib; {
    description = "DNS to DNS over HTTPS (DoH) proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    mainProgram = "https_dns_proxy";
  };
}
