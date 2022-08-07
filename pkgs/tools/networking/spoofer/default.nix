{ lib, stdenv, fetchurl, pkg-config, protobuf, openssl, libpcap, traceroute
, withGUI ? false, qt5 }:

let inherit (lib) optional;
in

stdenv.mkDerivation rec {
  pname = "spoofer";
  version = "1.4.8";

  src = fetchurl {
    url = "https://www.caida.org/projects/spoofer/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-npSBC4uE22AF14vR2xPX9MEwflDCiCTifgYpxav9MXw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl protobuf libpcap traceroute ]
                ++ optional withGUI qt5.qtbase ;

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://www.caida.org/projects/spoofer";
    description = "Assess and report on deployment of source address validation";
    longDescription = ''
      Spoofer is a new client-server system for Windows, MacOS, and
      UNIX-like systems that periodically tests a network's ability to
      both send and receive packets with forged source IP addresses
      (spoofed packets). This can be used to produce reports and
      visualizations to inform operators, response teams, and policy
      analysts. The system measures different types of forged
      addresses, including private and neighboring addresses.  The
      test results allows to analyze characteristics of networks
      deploying source address validation (e.g., network location,
      business type).
    '';
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leenaars];
  };
}
