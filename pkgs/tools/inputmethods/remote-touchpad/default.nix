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
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E2Pa5fhE2AiN2GE7k80nWcrXxHBDvkQtZV43DKhaCGU=";
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-vL6kSm0yPEn5TNpB6E+2+Xjm/ANNUxgA8XEWz9n7kHI=";

  meta = with lib; {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
