{ lib
, buildPythonApplication
, fetchFromGitHub
, nixFlakes
, nix-prefetch
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "sha256-cMllWFPK6pwqrocjkZKjnELIdtW4tj5Yu6AMw7Zd2JU=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ nixFlakes nix-prefetch ])
  ];

  checkPhase = ''
    $out/bin/nix-update --help >/dev/null
  '';

  meta = with lib; {
    description = "Swiss-knife for updating nix packages";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 zowoq ];
    platforms = platforms.all;
  };
}
