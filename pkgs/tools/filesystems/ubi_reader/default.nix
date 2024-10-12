{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ubi_reader";
  version = "0.8.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-04HwzkonPzzWfX8VE//fMoVv5ggAS+61zx2W8VEUIy4=";
  };

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];
  propagatedBuildInputs = with python3.pkgs; [ lzallright ];

  # There are no tests in the source
  doCheck = false;

  meta = with lib; {
    description = "Collection of Python scripts for reading information about and extracting data from UBI and UBIFS images";
    homepage = "https://github.com/onekey-sec/ubi_reader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vlaci ];
  };
}
