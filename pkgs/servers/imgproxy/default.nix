{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.13.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-0VB2nXVUtnAqM+cblYaulHFMv6dmztqiBwAxW/Ui1hs=";
    rev = "v${version}";
  };

  vendorHash = "sha256-6rEGuuw3UJyWeaIm9v5P8/V0Nxd9ySe0PCf0rWRDB9s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gobject-introspection vips ]
    ++ lib.optionals stdenv.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    homepage = "https://imgproxy.net";
    changelog = "https://github.com/imgproxy/imgproxy/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
