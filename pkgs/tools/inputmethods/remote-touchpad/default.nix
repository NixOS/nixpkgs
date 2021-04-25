{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, libXi
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zmbn4s3yhcgmijc96vja7zj2sh6q0nkybhqy0fwz6sqzk8hq02x";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  buildFlags = [ "-tags" "portal,x11" ];

  vendorSha256 = "0q1qk5g7kqpcci5fgamvxa8989jglv69kwg5rvkphbnx1bzlivrl";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
