{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "volatility3";
  version = "1.0.1";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k56izgkla9mrjrkp1saavajdx9x1wkqpwmbpvxv9rw5k80m5a4a";
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
