{ lib, stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "tcpdump";
  version = "4.99.3";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/tcpdump-${version}.tar.gz";
    sha256 = "sha256-rXWm7T3A2XMpRbLlSDy0Hci0tSihaTFeSZxoYZUuc7M=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeCheckInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "ac_cv_linux_vers=2";

  meta = with lib; {
    description = "Network sniffer";
    homepage = "https://www.tcpdump.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;
  };
}
