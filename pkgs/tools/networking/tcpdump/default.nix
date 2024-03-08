{ lib, stdenv, fetchurl, libpcap, pkg-config, perl }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.99.4";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/tcpdump-${version}.tar.gz";
    hash = "sha256-AjIjG7LynWvyQm5woIp+DGOg1ZqbRIY7f14jV6bkn+o=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = lib.optional (stdenv.hostPlatform.isStatic) [ pkg-config ];

  nativeCheckInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "ac_cv_linux_vers=2";

  meta = with lib; {
    description = "Network sniffer";
    homepage = "https://www.tcpdump.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
    mainProgram = "tcpdump";
  };
}
