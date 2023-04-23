{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "phantomsocks";
  version = "unstable-2023-04-05";

  src = fetchFromGitHub {
    owner = "macronut";
    repo = pname;
    rev = "a54ae9f3611e8623f89e69273f2ded7f7c0a7abf";
    hash = "sha256-ytTLwKlwbaiSWDRZBkOV7Hrl5ywWzLbv/fJ7nVlD++E=";
  };

  vendorHash = "sha256-c0NQfZuMMWz1ASwFBcpMNjxZwXLo++gMYBiNgvT8ZLQ=";

  meta = with lib;{
    homepage = "https://github.com/macronut/phantomsocks";
    description = "A cross-platform proxy client/server for Linux/Windows/macOS";
    longDescription = ''
      A cross-platform proxy tool that could be used to modify TCP packets
      to implement TCB desync to bypass detection and censoring.
    '';
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oluceps ];
  };
}
