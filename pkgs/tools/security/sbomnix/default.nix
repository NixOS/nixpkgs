{ lib
, fetchFromGitHub
, coreutils
, curl
, gnugrep
, gnused
, gzip
, nix
, python
  # python libs
, colorlog
, graphviz
, numpy
, packageurl-python
, pandas
, requests
, reuse
, tabulate
}:

python.pkgs.buildPythonApplication rec {
  pname = "sbomnix";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "tiiuae";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RxDFxVGivVBw2uhtzf231Q2HHTBFKSqGrknr2Es/ygM=";
  };

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ coreutils curl gnugrep gnused gzip graphviz nix ]}"
  ];

  propagatedBuildInputs = [
    colorlog
    graphviz
    numpy
    packageurl-python
    pandas
    requests
    reuse
    tabulate
  ];

  pythonImportsCheck = [ "sbomnix" ];

  meta = with lib; {
    description = "Generate SBOMs for nix targets";
    homepage = "https://github.com/tiiuae/sbomnix";
    license = with licenses; [ asl20 bsd3 cc-by-30 ];
    maintainers = with maintainers; [ henrirosten jk ];
  };
}
