{ lib, nimPackages, fetchFromGitHub }:
nimPackages.buildNimPackage rec {
  pname = "promexplorer";
  version = "0.0.5";
  nimBinOnly = true;
  src = fetchFromGitHub {
    owner = "marcusramberg";
    repo = "promexplorer";
    rev = "v${version}";
    hash = "sha256-a+9afqdgLgGf2hOWf/QsElq+CurDfE1qDmYCzodZIDU=";
  };

  buildInputs = with nimPackages; [ illwill illwillwidgets ];

  meta = with lib; {
    description = "A simple tool to explore prometheus exporter metrics";
    homepage = "https://github.com/marcusramberg/promexplorer";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ marcusramberg ];
  };
}
