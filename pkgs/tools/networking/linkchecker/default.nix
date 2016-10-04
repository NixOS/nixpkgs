{ stdenv, lib, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "LinkChecker-${version}";
  version = "9.3";

  # LinkChecker 9.3 only works with requests 2.9.x
  propagatedBuildInputs = with python2Packages ; [ requests2 ]; 

  src = fetchurl {
    url = "mirror://pypi/L/LinkChecker/${name}.tar.gz";
    sha256 = "0v8pavf0bx33xnz1kwflv0r7lxxwj7vg3syxhy2wzza0wh6sc2pf";
  };

  # upstream refuses to support ignoring robots.txt
  patches = [
    ./add-no-robots-flag.patch
  ];

  postInstall = ''
    rm $out/bin/linkchecker-gui
  '';

  meta = {
    description = "Check websites for broken links";
    homepage = "https://wummel.github.io/linkchecker/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
