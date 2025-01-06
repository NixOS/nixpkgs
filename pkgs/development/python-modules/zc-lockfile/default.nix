{
  buildPythonPackage,
  fetchPypi,
  mock,
  zope-testing,
  lib,
}:

buildPythonPackage rec {
  pname = "zc-lockfile";
  version = "3.0.post1";

  src = fetchPypi {
    pname = "zc.lockfile";
    inherit version;
    hash = "sha256-rbLubZ5qIzPJEXjcssm5aldEx47bdxLceEp9dWSOgew=";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ zope-testing ];

  meta = with lib; {
    description = "Inter-process locks";
    homepage = "https://www.python.org/pypi/zc.lockfile";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
