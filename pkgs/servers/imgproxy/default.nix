{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.18.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-gtCDeWQLXdhNc5Gn9020ib0IZxjVkHnOUHNf1vqsc0k=";
    rev = "v${version}";
  };

  vendorHash = "sha256-5o1i88v+1UGYXP2SzyM6seyidrj1Z3Q64w/gi07xf4w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ]
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
