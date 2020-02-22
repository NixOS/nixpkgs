{ lib, python2Packages }:

# Using python 2 because when packaging with python 3 pipreqs fails to parse python 2 code.
python2Packages.buildPythonApplication rec {
  pname = "pipreqs";
  version = "0.4.10";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "0fdr3mbxjpmrxr7yfc1sn9kbpcyb0qwafimhhrrqvf989dj1sdcy";
  };

  propagatedBuildInputs = with python2Packages; [ yarg docopt ];

  # Tests requires network access. Works fine without sandboxing
  doCheck = false;

  meta = with lib; {
    description = "Generate requirements.txt file for any project based on imports";
    homepage = https://github.com/bndr/pipreqs;
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
