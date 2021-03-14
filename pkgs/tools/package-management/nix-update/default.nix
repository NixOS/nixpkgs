{ lib
, buildPythonApplication
, fetchFromGitHub
, nixFlakes
, nix-prefetch
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "1ykxr0yah7zl06igm7wiji9zx3y0xpjc37hbfhn6gnir6ssa0kqp";
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
