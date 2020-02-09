{ lib
, substituteAll
, buildPythonPackage
, fetchPypi
, sphinx
, pdf2svg
, texLive
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-tikz";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rvm0l40iz1z03d09irkqdwzi9gs6pn0203hylaqbix5c7gabwhy";
  };

  patches = [
    (substituteAll {
      src = ./binary-paths.patch;
      inherit texLive pdf2svg;
    })
  ];

  propagatedBuildInputs = [ sphinx ];

  # no tests in package
  doCheck = false;

  meta = with lib; {
    description = "TikZ extension for Sphinx";
    homepage = https://bitbucket.org/philexander/tikz;
    maintainers = with maintainers; [ costrouc ];
    license = licenses.bsd3;
  };

}
