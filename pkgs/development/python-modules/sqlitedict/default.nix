{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "sqlitedict";
    rev = "refs/tags/${version}";
    sha256 = "sha256-8dmGn5h3NigCdDtnDYjpjntRpyjk7ivRp1B8x8nUgpE=";
  };

  preCheck = ''
    mkdir tests/db
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/RaRe-Technologies/sqlitedict";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
