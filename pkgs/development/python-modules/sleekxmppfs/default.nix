{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
  pyasn1,
  pyasn1-modules,
}:

buildPythonPackage rec {
  pname = "sleekxmppfs";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aszymanik";
    repo = "SleekXMPP";
    rev = "refs/tags/sleek-${version}";
    hash = "sha256-E2S4fMk5dRr8g42iOYmKOknHX7NS6EZ/LAZKc1v3dPg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    pyasn1
    pyasn1-modules
  ];

  pythonImportsCheck = [ "sleekxmppfs" ];

  # tests weren't adapted for the fork
  doCheck = false;

  meta = {
    description = "A fork of SleekXMPP with TLS cert validation disabled, intended only to be used with the sucks project";
    license = lib.licenses.mit;
    homepage = "https://github.com/aszymanik/SleekXMPP";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
