{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "105mjlbzgv1c8argwgs0d9wm28m06nqi5hrk3358zg2jaa7ahaqf";
    rev = "v${version}";
  };

  vendorSha256 = "069if1ifsmdn5hrwybiifhnq6xzmdccq85mzi9v98iii18pzfwqx";

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
