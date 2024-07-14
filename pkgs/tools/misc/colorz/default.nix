{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "colorz";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wE/2OJYoHy7hMnvN/y52ozn3BVmr2KJdKMDR+yhIDT4=";
  };

  propagatedBuildInputs = with python3Packages; [ pillow scipy ];

  checkPhase = ''
    $out/bin/colorz --help > /dev/null
  '';

  meta = with lib; {
    description = "Color scheme generator";
    homepage = "https://github.com/metakirby5/colorz";
    license = licenses.mit;
    maintainers = with maintainers; [ skykanin ];
    mainProgram = "colorz";
  };
}
