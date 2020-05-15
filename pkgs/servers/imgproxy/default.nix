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