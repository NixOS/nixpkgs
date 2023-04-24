{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "pecli";
  version = "0.1.4";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-+BVMBqAFfveJy9I9KeoNJpWv8U3OJOzuyyy+cIl5WoA=";
  };

  propagatedBuildInputs = with python3.pkgs; [ pefile yara-python python-magic virustotal-api ipython ];

  meta = with lib; {
    homepage = "https://github.com/Te-k/pecli";
    maintainers = with lib.maintainers; [ jordanisaacs ];
    license = lib.licenses.mit;
  };
}
