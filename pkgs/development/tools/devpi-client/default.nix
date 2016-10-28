{ stdenv, fetchurl, pythonPackages, glibcLocales} :

pythonPackages.buildPythonApplication rec {
  name = "devpi-client-${version}";
  version = "2.7.0";

  src = fetchurl {
    url = "mirror://pypi/d/devpi-client/${name}.tar.gz";
    sha256 = "0z7vaf0a66n82mz0vx122pbynjvkhp2mjf9lskgyv09y3bxzzpj3";
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
