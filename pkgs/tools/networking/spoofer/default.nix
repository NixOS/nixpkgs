{ stdenv, fetchurl, pkgconfig, protobuf, openssl, libpcap, traceroute
, withGUI ? false, qt5 }:

let inherit (stdenv.lib) optional optionalString;
in

stdenv.mkDerivation rec {
  pname = "spoofer";
  version = "1.3.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.caida.org/projects/spoofer/downloads/${name}.tar.gz";
    sha256 = "05297dyyq8bdpbr3zz974l7vm766lq1bsxvzp5pa4jfpvnj7cl1g";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl protobuf libpcap traceroute ]
                ++ optional withGUI qt5.qtbase ;

  meta = with stdenv.lib; {
    homepage = https://www.caida.org/projects/spoofer;
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
    maintainers = with stdenv.lib.maintainers; [ leenaars];
  };
}
