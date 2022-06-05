{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-VS2EZUMUvzuSP/Rs0pY0qo5VcB9VU3+IzZG6AdTrhmk=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-Rp0vTtpdKpYg/7UjX73Qwxu6dOqDr24nqp41fKN1IYw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ]
    ++ lib.optionals stdenv.isDarwin [ libunwind ];

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
