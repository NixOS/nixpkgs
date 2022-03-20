{ lib, crystal, fetchFromSourcehut, mkYarnPackage, runCommand, jq, openssl }:

let
  pname = "scribe";
  version = "unstable-2022-03-12";

  src = fetchFromSourcehut {
    owner = "~edwardloveall";
    repo = pname;
    rev = "80b6b5180412ee75622ea11dbf086950ec40f9d7";
    hash = "sha256-sjfBdPbkdXFmA4aZLgujLSVrJ/LPYzWqchIoQhktAos=";
  };

  publicFiles = mkYarnPackage {
    pname = "${pname}-public";
    inherit version src;

    # Use patched package.json with name and version added
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    configurePhase = "cp -r $node_modules node_modules";
    buildPhase = "yarn run --offline mix --production";
    installPhase = "cp -r public $out";
    distPhase = "true";
  };
in
crystal.buildCrystalPackage rec {
  inherit pname version src;

  format = "crystal";
  shardsFile = ./shards.nix;
  crystalBinaries.scribe.src = "src/scribe.cr";
  crystalBinaries.lucky_tasks.src = "tasks.cr";

  buildInputs = [ openssl ];
  doCheck = false; # require postgresql
  doInstallCheck = false; # freeze

  preBuild = ''
    # Build requires public/mix-manifest.json
    cp -r ${publicFiles}/* public
  '';
  postInstall = ''
    mkdir -p $out/share/scribe
    cp -r public $out/share/scribe/public
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~edwardloveall/scribe";
    description = "An alternative Medium frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.unix;
  };
}
