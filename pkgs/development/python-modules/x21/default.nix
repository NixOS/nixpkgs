{ lib
, fetchurl
, buildPythonPackage
, glib
, autoPatchelfHook
}:

buildPythonPackage rec {
  pname = "x21";
  version = "0.3.3";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/ad/b1/56beb31fdc87ef8599522173c65b37629e01fb9a93a5eb6060d83c00933d/x21-0.3.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    sha256 = "sha256-j0C6R+/FVqrgQAveu8MigatLWGyTmdpPMH/9+AsDpPg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  propagatedBuildInputs = [ glib ];

  pythonImportsCheck = [ "x21" ];

  meta = with lib; {
    description = "Meshzoo dependency";
    homepage = "https://pypi.org/project/x21";
    # Unspecified license therefore unfree
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
  };
}
