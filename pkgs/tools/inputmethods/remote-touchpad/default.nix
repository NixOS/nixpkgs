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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dSBkRBT3crdoO3JB3kVSUDC0faRrxa/R5MF/3a9POxo=";
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-B/nxV9iHebe3v7VM+TTFGnAnPcBICtW+rDyrNNY6Ixw=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
