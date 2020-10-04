{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "0p6vy5b6dhv23qnn6sk99hn0j5wiwqpaprsg5jgm2wxb0w2bfz0w";
    rev = "v${version}";
  };

  vendorSha256 = "0jrp778cjr8k8sbal0yn1zy7s9sj534q9i90qv4c29fxd9xw7qgp";

  doCheck = false;

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
