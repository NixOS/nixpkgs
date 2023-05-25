{ buildGoModule
, fetchFromGitHub
, lib
, libXi
, libXrandr
, libXt
, libXtst
}:

buildGoModule rec {
  pname = "remote-touchpad";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3P72DWwDvmlWM73nzbj1UceWv/CNuCu7+LnBDlCDlgo=";
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-SYh1MhJUrJKguR12L3yyxHoBB6ux6a4TUJyPvoYx7iU=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
