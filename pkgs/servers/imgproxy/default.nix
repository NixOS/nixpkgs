{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-GZYaFK6g26gbVa3sHwTZ4fNGMFWBWevqcfJc/3SC890=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-uV5pnnvVYviw2LnceQUiTJXva3WI51pgW6IeZzVhULc=";

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
