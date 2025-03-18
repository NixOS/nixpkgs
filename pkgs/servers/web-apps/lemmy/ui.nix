{ lib
, stdenvNoCC
, libsass
, nodejs
, python3
, pkg-config
, pnpm_9
, fetchFromGitHub
, nixosTests
, vips
, nodePackages
}:

let
  pinData = lib.importJSON ./pin.json;


in

stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "lemmy-ui";
  version = pinData.uiVersion;

  src = with finalAttrs; fetchFromGitHub {
    owner = "LemmyNet";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = pinData.uiHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  buildInputs = [libsass vips ];

  extraBuildInputs = [ libsass ];
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = pinData.uiPNPMDepsHash;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build:prod

    runHook postBuild
  '';

  # installPhase = ''
  #     runHook preInstall

  #     mkdir -p $out/{bin,lib/${finalAttrs.pname}}
  #     mv {dist,node_modules} $out/lib/${finalAttrs.pname}

  #     runHook postInstall

  #  '';
    preInstall = ''
    mkdir $out
    cp -R ./dist $out
    cp -R ./node_modules $out
  '';


  distPhase = "true";

  passthru.updateScript = ./update.py;
  passthru.tests.lemmy-ui = nixosTests.lemmy;
  passthru.commit_sha = finalAttrs.src.rev;

  meta = with lib; {
    description = "Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada billewanick georgyo ];
    inherit (nodejs.meta) platforms;
  };
})
