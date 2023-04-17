{ lib, nimPackages, fetchFromGitHub }:
nimPackages.buildNimPackage rec {
  pname = "promexplorer";
  version = "0.0.3";
  nimBinOnly = true;
  src = fetchFromGitHub {
    owner = "marcusramberg";
    repo = "promexplorer";
    rev = "v${version}";
    hash = "sha256-q+m4+aWT3IiI/XGmAm7jrJAxRbzzHr+p58eiHqjEbV0=";
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
