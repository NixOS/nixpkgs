{ lib
, fetchPypi
, python3
,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "catppuccin-catwalk";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "catppuccin_catwalk";
    hash = "sha256-5TAw5H3soxe9vLhfj1qs8uMr4ybrHlCj4zdsMzvPo6s=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pillow
  ];

  pythonImports = [
    "catwalk"
  ];

  meta = with lib; {
    homepage = "https://github.com/catppuccin/toolbox";
    description = "A CLI for Catppuccin that takes in four showcase images and displays them all at once";
    license = licenses.mit;
    maintainers = with maintainers; [ ryanccn ];
  };
}
