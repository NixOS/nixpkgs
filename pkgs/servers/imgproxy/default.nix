{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-LJsiZeKgetFTqX58I82jDr8fIgYJCDVhb44yg8uc/8w=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-088VEntNx3ZX2p6EiAZ6nSeWmM32XLAOmqXu2sd9QG4=";

  doCheck = false;

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
