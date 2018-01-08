{ stdenv, lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedometer-${version}";
  version = "2.8";
  src = fetchurl {
    url = "https://excess.org/speedometer/speedometer-${version}.tar.gz";
    sha256 = "060bikv3gwr203jbdmvawsfhc0yq0bg1m42dk8czx1nqvwvgv6fm";
  };
  propagatedBuildInputs = [ pythonPackages.urwid ];
  meta = with lib; {
    description = "Measure and display the rate of data across a network connection or data being stored in a file";
    homepage = https://excess.org/speedometer/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Baughn ];
  };
}
