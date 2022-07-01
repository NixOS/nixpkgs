{ lib, fetchFromGitHub, python3Packages, httpie }:

python3Packages.buildPythonApplication rec {
  pname = "http-prompt";
  version = "1.0.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0kngz2izcqjphbrdkg489p0xmf65xjc8ki1a2szcc8sgwc7z74xy";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    httpie
    parsimonious
    (python.pkgs.callPackage ../../../development/python-modules/prompt-toolkit/1.nix {})
    pygments
    six
  ];

  checkPhase = ''
    $out/bin/${pname} --version | grep -q "${version}"
  '';

  meta = with lib; {
    description = "An interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    homepage = "https://github.com/eliangcs/http-prompt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
