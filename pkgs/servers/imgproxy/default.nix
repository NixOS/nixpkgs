{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-T82z6rqS4mCXo0844xe4VZzI5AScn0dPWvu9q8nO2uQ=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-QwmrxG3DMXdw/MQKChlP/icc9s5x85vbrRKoael4Bc4=";

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
