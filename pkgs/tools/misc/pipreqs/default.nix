{ lib, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "pipreqs";
  version = "0.4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fdr3mbxjpmrxr7yfc1sn9kbpcyb0qwafimhhrrqvf989dj1sdcy";
  };

  propagatedBuildInputs = [ yarg docopt ];

  # Tests requires network access. Works fine without sandboxing
  doCheck = false;

  meta = with lib; {
    description = "Generate requirements.txt file for any project based on imports";
    homepage = "https://github.com/bndr/pipreqs";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
