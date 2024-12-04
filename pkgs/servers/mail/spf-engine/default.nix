{ lib, buildPythonApplication, fetchurl, flit-core, pyspf, dnspython, authres, pymilter }:

buildPythonApplication rec {
  pname = "spf-engine";
  version = "3.0.4";
  format = "pyproject";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/${lib.versions.majorMinor version}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "sha256-Gcw7enNIb/TrZEYa0Z04ezHUmfMmc1J+aEH6FlXbhTo=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pyspf dnspython authres pymilter ];

  pythonImportsCheck = [
    "spf_engine"
    "spf_engine.milter_spf"
    "spf_engine.policyd_spf"
  ];

  meta = with lib; {
    homepage = "https://launchpad.net/spf-engine/";
    description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
  };
}
