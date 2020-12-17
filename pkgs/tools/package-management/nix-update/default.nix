{ lib
, buildPythonApplication
, fetchFromGitHub
, nixFlakes
, nix-prefetch
}:

buildPythonApplication rec {
  pname = "nix-update";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = version;
    sha256 = "12fsxy2rv2dgk8l10ymp10j01jkcbn9w0fv5iyb5db85q4xsrsm5";
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
