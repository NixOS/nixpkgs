{
  lib,
  buildPythonApplication,
  fetchurl,
  flit-core,
  pyspf,
  dnspython,
  authres,
  pymilter,
}:

buildPythonApplication rec {
  pname = "spf-engine";
  version = "3.1.0";
  pyproject = true;

  src = fetchurl {
    url = "https://launchpad.net/${pname}/${lib.versions.majorMinor version}/${version}/+download/spf-engine-${version}.tar.gz";
    hash = "sha256-HUuMxYFCqItLFgMSnrkwfmJWqgFGyI1RWgmljb+jkWk=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    pyspf
    dnspython
    authres
    pymilter
  ];

  pythonImportsCheck = [
    "spf_engine"
    "spf_engine.milter_spf"
    "spf_engine.policyd_spf"
  ];

  meta = {
    homepage = "https://launchpad.net/spf-engine/";
    description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
