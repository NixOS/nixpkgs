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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VgTjQXjJn17+BhREew62RTjNo8UWc4Fn9x+924nGD+I=";
  };

  buildInputs = [ libX11 libXi libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorSha256 = "sha256-Cw4uMnID0nDhSl+ijHMo1VcXLdY1bHFpEkqDQDJOJOw=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
