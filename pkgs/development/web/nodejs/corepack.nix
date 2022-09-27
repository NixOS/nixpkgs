{ lib, stdenv, nodejs }:

let
  inherit (nodejs) version;
in
stdenv.mkDerivation {
  name = "corepack-nodejs-${version}";

  nativeBuildInputs = [ nodejs ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    corepack enable --install-directory $out/bin
    # Also wrap npm
    corepack enable --install-directory $out/bin npm
  '';

  meta = {
    description = "Wrappers for npm, pnpm and yarn via nodejs's corepack";
    homepage = "https://nodejs.org";
    changelog = "https://github.com/nodejs/node/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wmertens ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
