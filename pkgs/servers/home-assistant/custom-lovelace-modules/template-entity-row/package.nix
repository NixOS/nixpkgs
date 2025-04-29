{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "template-entity-row";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-template-entity-row";
    rev = "v${version}";
    hash = "sha256-XQxdnRQywWki5mJhmQU5Etz2XSB8jYC32tFGLWb3IXs=";
  };

  npmDepsHash = "sha256-fJ+2LWXtUH4PiHhoVhMMxdCnCjfH+xzk+vjI44rKF60=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp template-entity-row.js $out/

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/thomasloven/lovelace-template-entity-row/releases/tag/${src.rev}";
    description = "Display whatever you want in an entities card row";
    homepage = "https://github.com/thomasloven/lovelace-template-entity-row";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.all;
  };
}
