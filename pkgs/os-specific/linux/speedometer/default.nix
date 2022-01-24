{ lib, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "speedometer";
  version = "2.8";

  src = fetchurl {
    url = "https://excess.org/speedometer/speedometer-${version}.tar.gz";
    sha256 = "060bikv3gwr203jbdmvawsfhc0yq0bg1m42dk8czx1nqvwvgv6fm";
  };

  propagatedBuildInputs = [ python2Packages.urwid ];

  postPatch = ''
    sed -i "/'entry_points': {/d" setup.py
    sed -i "/'console_scripts': \['speedometer = speedometer:console'\],},/d" setup.py
  '';

  meta = with lib; {
    description = "Measure and display the rate of data across a network connection or data being stored in a file";
    homepage = "https://excess.org/speedometer/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Baughn ];
  };
}
