{ lib, poetry2nix, fetchPypi }:

poetry2nix.mkPoetryApplication rec {
  pname = "stacki3";
  version = "1.0.0";

  projectDir = fetchPypi {
    inherit pname version;
    hash = "sha256-NOYSF+34GRoCd1sgjqXkETsVovsuh+E1TEmBIOAsX7Y=";
  };

  pyproject  = ./pyproject.toml;
  poetrylock = ./poetry.lock;

  meta = with lib; {
    homepage = "https://github.com/ViliamV/stacki3";
    description = "Stack layout for i3/sway wm";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
