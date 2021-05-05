{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
}:

buildPythonPackage rec {
  pname = "yacs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "rbgirshick";
    repo = "yacs";
    rev = "v${version}";
    sha256 = "17ah2k8hpwgsqp1l1wzvz718a9rfj5rwa5vnhpnz94akicphbvww";
  };

  nativeBuildInputs = [
    pyyaml
  ];

  meta = with lib; {
    description = "Yet Another Configuration System";
    homepage = "https://github.com/rbgirshick/yacs";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
