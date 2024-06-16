{ lib, fetchFromGitHub, python3Packages, httpie }:

python3Packages.buildPythonApplication rec {
  pname = "http-prompt";
  version = "2.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "httpie";
    sha256 = "sha256-e4GyuxCeXYNsnBXyjIJz1HqSrqTGan0N3wxUFS+Hvkw=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    httpie
    parsimonious
    (python.pkgs.callPackage ../../../development/python-modules/prompt-toolkit/1.nix {})
    pygments
    six
    pyyaml
  ];

  checkPhase = ''
    $out/bin/${pname} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "An interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    mainProgram = "http-prompt";
    homepage = "https://github.com/eliangcs/http-prompt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
