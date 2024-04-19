{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pwdsafety";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cKxTcfNjvwcDEw0Z1b50A4u0DUYXlGMMfGWJLPaSkcw=";
  };

  vendorHash = "sha256-RoRq9JZ8lOMtAluz8TB2RRuDEWFOBtWVhz21aTkXXy4=";

  meta = with lib; {
    description = "Command line tool checking password safety";
    mainProgram = "cmd";
    homepage = "https://github.com/edoardottt/pwdsafety";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
