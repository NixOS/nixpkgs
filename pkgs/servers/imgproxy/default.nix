{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-qTOMoeTk9fGBSmioTRBUa3xRXOIW6OJj8aH0b/vP7dw=";
    rev = "v${version}";
  };

  vendorHash = "sha256-SaxoFCEDniphr1ZZ5prE996CeHegB+a8dpGaMpjsrtQ=";

  nativeBuildInputs = [ pkg-config gobject-introspection ];

  buildInputs = [ vips ]
    ++ lib.optionals stdenv.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    changelog = "https://github.com/imgproxy/imgproxy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
