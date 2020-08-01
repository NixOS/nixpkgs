{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "048bfkazjijf7p0wb5y09qhl7pgg297xxshgmkfyr025d7d50lf4";
    rev = "v${version}";
  };

  vendorSha256 = "1pvyr3lazza89njdl6q3h2nd0mkvjvbryyrfqv11kd3s52055ckz";

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
