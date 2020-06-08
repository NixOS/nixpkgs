{ fetchFromGitHub, buildPythonPackage, python3Packages, lib }:

buildPythonPackage rec {
  pname = "torchfile";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bshillingford";
    repo = "python-${pname}";
    rev = version;
    sha256 = "0ffajg536jhm772k0kcm3m721rq6j6ldxfjz0hmad0x85dhcr7v2";
  };

  checkInputs = with python3Packages; [
    numpy
  ];

  meta = with lib; {
    description = "Deserialize Lua torch-serialized objects from Python";
    homepage = "https://github.com/bshillingford/python-torchfile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
