{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "gh2md";
  version = "2.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "7a277939d4781f4ca741eccb74fc70f0aa85811185da52219878129cba7f1d77";
  };

  propagatedBuildInputs = with python3Packages; [ six requests python-dateutil ];

  # uses network
  doCheck = false;

  pythonImportsCheck = [ "gh2md" ];

  meta = with lib; {
    description = "Export Github repository issues to markdown files";
    homepage = "https://github.com/mattduck/gh2md";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
  };
}
