{ lib
, buildPythonApplication
, colorlog
, fetchFromGitHub
, git
, importlab
, online-judge-tools
, pyyaml
, setuptools
, toml
}:

buildPythonApplication rec {
  pname = "online-judge-verify-helper";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "verification-helper";
    rev = "v${version}";
    hash = "sha256-sBR9/rf8vpDRbRD8HO2VNmxVckXPmPjUih7ogLRFaW8=";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace onlinejudge_verify/main.py --subst-var-by git ${git}
  '';

  propagatedBuildInputs = [
    colorlog
    importlab
    online-judge-tools
    pyyaml
    setuptools
    toml
  ];

  # Needs internet to run tests
  doCheck = false;

  meta = with lib; {
    description = "A testing framework for snippet libraries used in competitive programming";
    homepage = "https://github.com/online-judge-tools/verification-helper";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
