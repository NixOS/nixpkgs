{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "isolyzer";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "KBNLresearch";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-NqkjnEwpaoyguG5GLscKS9UQGtF9N4jUL5JhrMtKCFE=";
  };

  propagatedBuildInputs = with python3.pkgs; [ setuptools six ];

  meta = with lib; {
    homepage = "https://github.com/KBNLresearch/isolyzer";
    description = "Verify size of ISO 9660 image against Volume Descriptor fields";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
