{ stdenv, lib, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "speedometer-${version}";
  version = "2.8";

  src = fetchurl {
    url = "http://excess.org/speedometer/speedometer-${version}.tar.gz";
    sha256 = "060bikv3gwr203jbdmvawsfhc0yq0bg1m42dk8czx1nqvwvgv6fm";
  };

  propagatedBuildInputs = [ pythonPackages.urwid ];

  postPatch = ''
    sed -i "/'entry_points': {/d" setup.py
    sed -i "/'console_scripts': \['speedometer = speedometer:console'\],},/d" setup.py
  '';

  meta = with lib; {
    description = "Measure and display the rate of data across a network connection or data being stored in a file";
    homepage = http://excess.org/speedometer/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Baughn ];
  };
}
