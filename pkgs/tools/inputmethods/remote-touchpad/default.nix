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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GjXcQyv55yJSAFeNNB+YeCVWav7vMGo/d1FCPoujYjA=";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorSha256 = "sha256-WG8OjtfVemtmHkrMg4O0oofsjtFKmIvcmCn9AYAGIrc=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
