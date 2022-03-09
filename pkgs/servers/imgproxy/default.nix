{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-8oUPqtoxdJ768CmDNBicBGCyejt2v9GIahVRL6pYDJ4=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-Dr5qCLVsv22BcISo2OyB+VEDncPwpcp323w9IfDTQv0=";

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
