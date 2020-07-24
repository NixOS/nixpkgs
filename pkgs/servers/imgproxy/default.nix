{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "1vmjdybrkxs1h19g14dhc49xpshwa5mwr5pbpb7mq56awqcj0r11";
    rev = "v${version}";
  };

  vendorSha256 = "1vdl19qf20l13wnacpfficww4a2hdkhgnh15ib45v9k3raam7s7i";

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
