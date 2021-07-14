{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "2.16.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    sha256 = "sha256-wrd8G2y8oepaHMJaU4Bcvkf91ABX4ZapQSlztq4Gg84=";
    rev = "v${version}";
  };

  vendorSha256 = "sha256-aV+A2duS13Zi9IPa7bd/tBe5NzmUhKYsXzvluuIFc+I=";

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
