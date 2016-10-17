{ stdenv, fetchurl, pythonPackages, glibcLocales} :

pythonPackages.buildPythonApplication rec {
  name = "devpi-client-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://pypi/d/devpi-client/${name}.tar.gz";
    sha256 = "22484d6a1ccc957d3e4f857e428244fb27c042baedd3bf28fe7522cd89d8ff45";
  };

  doCheck = false;

  LC_ALL = "en_US.UTF-8";
  buildInputs = with pythonPackages; [ glibcLocales tox check-manifest pkginfo ];

  propagatedBuildInputs = with pythonPackages; [ py devpi-common ];

  meta = {
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ lewo makefu ];

  };
}
