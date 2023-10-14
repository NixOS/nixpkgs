{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-EGnamJBotPDatsWG+XLI/QhF2464aphkB9oS631oj+c=";
    rev = "v${version}";
  };

  vendorHash = "sha256-gjRUt8/LECFSU2DG4ALi7a3DxKAGFoW98eBgeE5i2+s=";

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
