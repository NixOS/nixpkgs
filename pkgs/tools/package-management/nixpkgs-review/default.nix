{ lib
, python3
, fetchFromGitHub
, nixUnstable
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    rev = version;
    sha256 = "0991jz2l834pyzwcrkvjf3wlp122fkkz6avs4j5n9idv549c5xc0";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ nixUnstable git ]}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 SuperSandro2000 ];
  };
}
