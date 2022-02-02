{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "volatility3";
  version = "2.0.0";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = pname;
    rev = "v${version}";
    sha256 = "141n09cdc17pfdhs01aw8l4cvsqpcz8ji5l4gi7r88cyf4ix2lnz";
  };

  propagatedBuildInputs = with python3.pkgs; [
    capstone
    jsonschema
    pefile
    pycryptodome
    yara-python
  ];

  preBuild = ''
    export HOME=$(mktemp -d);
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "volatility3" ];

  meta = with lib; {
    description = "Volatile memory extraction frameworks";
    homepage = "https://www.volatilityfoundation.org/";
    license = {
      # Volatility Software License 1.0
      free = false;
      url = "https://www.volatilityfoundation.org/license/vsl-v1.0";
    };
    maintainers = with maintainers; [ fab ];
  };
}
