{
  lib,
  stdenv,
  nodejs,
}:

stdenv.mkDerivation {
  pname = "corepack-nodejs";
  inherit (nodejs) version;

  nativeBuildInputs = [ nodejs ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    corepack enable --install-directory $out/bin
    # Enabling npm caused some crashes - leaving out for now
    # corepack enable --install-directory $out/bin npm
  '';

  meta = with lib; {
    description = "Wrappers for npm, pnpm and Yarn via Node.js Corepack";
    homepage = "https://nodejs.org/api/corepack.html";
    changelog = "https://github.com/nodejs/node/releases/tag/v${nodejs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ wmertens ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
