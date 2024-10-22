{ lib, buildGoModule, fetchFromGitHub, pkg-config, vips, gobject-introspection
, stdenv, libunwind }:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.26.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-sjgSbKKTUq6HL7QZ3LNU1Eo+2n/KnlY7Yt80lXAR26k=";
    rev = "v${version}";
  };

  vendorHash = "sha256-YxZuAo8l3fhCGCEQVPzKeVdL7i4jWe8rZ5pILI4NVP4=";

  nativeBuildInputs = [ pkg-config gobject-introspection ];

  buildInputs = [ vips ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    mainProgram = "imgproxy";
    homepage = "https://imgproxy.net";
    changelog = "https://github.com/imgproxy/imgproxy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
