{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "0lzk9nv7fbyc0jbsigw54310pvpwfrvji58z7a08j03vypc0v3x4";
    rev = "v${version}";
  };

  modSha256 = "02pj8ryis89dl4wjp2mvx6h5d0xdvskxdxiwarg7q0x23m9r7kpg";

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
