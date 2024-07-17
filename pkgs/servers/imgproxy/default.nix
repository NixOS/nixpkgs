{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  vips,
  gobject-introspection,
  stdenv,
  libunwind,
}:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-TkfyhePilOwuW6+MtTqYUYvpP/FnFhpsHt2APMFNbvo=";
    rev = "v${version}";
  };

  vendorHash = "sha256-LlVZRHotJcHtgeGXIDnbIwpO8iCrBB8nXBnqzHcrJWk=";

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [ vips ] ++ lib.optionals stdenv.isDarwin [ libunwind ];

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
