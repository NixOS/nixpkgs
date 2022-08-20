{ callPackage
, cypress
, nodejs-14_x
, # FIXME: duplicated from ./regen-nix. node2nix should expose this
  nodePackages
, xorg
, pkgs
, stdenv
,
}:

let
  fromNode2nix = import ./cypress-example-kitchensink.nix {
    inherit pkgs;
  };

  nodeDependencies = fromNode2nix.shell.nodeDependencies.overrideAttrs (o: {
    CYPRESS_INSTALL_BINARY = "0";
    PUPPETEER_SKIP_DOWNLOAD = "1";
  });

  fontConfigEtc = (
    pkgs.nixos { config.fonts.fontconfig.enable = true; }
  ).config.environment.etc.fonts.source;

in
stdenv.mkDerivation {
  name = "cypress-example-kitchensink";
  src = callPackage ./src.nix { };
  passthru.fc = fontConfigEtc;
  nativeBuildInputs = [
    cypress
    nodejs-14_x
    xorg.xorgserver
    nodePackages.jsonplaceholder
  ];
  FONTCONFIG_PATH = fontConfigEtc;
  postPatch = ''
    # Use our own offline backend. 15011 means js0n ;)
    sed -e 's^https://jsonplaceholder.cypress.io^http://localhost:15011^g' -i $(find . -type f)
  '';
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    PATH="${nodeDependencies}/bin:$PATH"
    runHook preBuild
    PORT=15011 jsonplaceholder &
    # assumption: jsonplaceholder start far quicker than cypress run

    export CYPRESS_RUN_BINARY=${cypress}/bin/Cypress
    export HOME=$PWD/home
    mkdir $HOME
    npm run test
    runHook postBuild
  '';
  installPhase = ''
    mkdir $out
    cp -r cypress/videos $out/
  '';
}
