{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-4P8Q8VM2+O4Du2u+LFmqGQYw8qvEuBGq2nz9FxvGQhE=";
    rev = "v${version}";
  };

  vendorHash = "sha256-TUu/dWtjs/ua3uwi029gtev0rcAZBCN9AHD9RPZsaDI=";

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
