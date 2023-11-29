{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "i3nator";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "pitkley";
    repo = pname;
    rev = version;
    sha256 = "10rxvxq48dhzlw5p9fsj6x0ci4pap85s9b192zakgvk4h97ifp2p";
  };

  cargoSha256 = "04sx1dsznvh60s2yd9bzbvj6fgjvj37vv33qpww13fyph832i37g";

  meta = with lib; {
    description = "Tmuxinator for the i3 window manager";
    homepage = "https://github.com/pitkley/i3nator";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mpoquet ];
    mainProgram = "i3nator";
  };
}
