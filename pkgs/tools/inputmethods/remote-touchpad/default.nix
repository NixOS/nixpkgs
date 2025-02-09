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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EfZ8h65jFVdy/U7I2YDoIMHgnnYpUcrOYUAMCPOmK6U=";
  };

  buildInputs = [ libXi libXrandr libXt libXtst ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-UX366UWROeorwYV4l1A3R03J10Gm7EajM+wEczIJEJM=";

  meta = with lib; {
    description = "Control mouse and keyboard from the webbrowser of a smartphone.";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
    platforms = platforms.linux;
  };
}
