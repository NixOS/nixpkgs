{
  lib,
  fetchFromGitHub,
  nix,
  python,
  matplotlib,
  networkx,
  pandas,
  pygraphviz,
  setuptools,
}:

python.pkgs.buildPythonApplication rec {
  version = "1.0.5-unstable-2024-01-17";
  pname = "nix-visualize";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "craigmbooth";
    repo = "nix-visualize";
    rev = "5b9beae330ac940df56433d347494505e2038904";
    hash = "sha256-VgEsR/Odddc7v6oq2tNcVwCYm08PhiqhZJueuEYCR0o=";
  };

  postInstall = ''
    wrapProgram $out/bin/nix-visualize \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    matplotlib
    networkx
    pandas
    pygraphviz
  ];

  pythonImportsCheck = [ "nix_visualize" ];
  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Generate dependency graphs of a given nix package";
    mainProgram = "nix-visualize";
    homepage = "https://github.com/craigmbooth/nix-visualize";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ henrirosten ];
  };
}
