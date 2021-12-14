{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vpk";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "vpk";
    rev = "v${version}";
    hash = "sha256-kFKu4fuclanMdlfA/2ZccglM7rSzaq9BbbSaKuIN+Pk=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library for working with Valve Pak files";
    homepage = "https://github.com/ValvePython/vpk";
    license = licenses.mit;
    maintainers = with maintainers; [ joshuafern ];
  };
}
