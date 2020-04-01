{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "1n91snf5sxsiy2r8y2nksw4ah70f70nxamy7k0ylgkpfxp4dxwb8";
    rev = "v${version}";
  };

  modSha256 = "1fm3s1ksah0w86xv8xjhrbf5ia0ynfg2qgajnldy3dpdbxa3yh7s";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
