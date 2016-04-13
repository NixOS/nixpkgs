{ stdenv, fetchurl, pythonPackages, python} :

pythonPackages.buildPythonApplication rec {
  name = "devpi-client-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/d/devpi-client/devpi-client-${version}.tar.gz";
    md5= "bfc8cd768f983fd0585c347bca00c8bb";
  };

  buildInputs = [ pythonPackages.tox pythonPackages.check-manifest pythonPackages.devpi-common pythonPackages.pkginfo ];
  meta = {
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.lewo];

  };
}
