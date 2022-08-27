{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-ggQOVBYdTmrkThzJSYjxk6Y9znq4dHvSX6ATjyhoHsw=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-LrUdOkapPwR9vtecQM0vn/B5fppMUW3luxT7pPelvvU=";

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
