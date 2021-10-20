{ pkgs
, lib
, stdenv
, buildRustCrate
, defaultCrateOverrides
, fetchFromGitHub
, Security
, features ? [ ]
}:

let
  version = "0.21.1";
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v${version}";
    sha256 = "sha256-wyyhTNhVw8EJhahstLK+QuEhufQC68rMpw/ngK8FL8Y=";
  };
  customBuildRustCrateForPkgs = pkgs: buildRustCrate.override {
    defaultCrateOverrides = defaultCrateOverrides // {
      meilisearch-http = attrs: {
        src = "${src}/meilisearch-http";
        buildInputs = lib.optionals stdenv.isDarwin [ Security ];
      };
      meilisearch-error = attrs: {
        src = "${src}/meilisearch-error";
      };
    };
  };
  cargo_nix = import ./Cargo.nix {
    inherit pkgs;
    buildRustCrateForPkgs = customBuildRustCrateForPkgs;
  };
  meilisearch-http = cargo_nix.workspaceMembers."meilisearch-http".build.override {
    inherit features;
  };
in
stdenv.mkDerivation {
  pname = "meilisearch";
  inherit version src;
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${meilisearch-http}/bin/meilisearch $out/bin/meilisearch
  '';
  dontCheck = true;
  dontFixup = true;
  meta = with lib; {
    description = "Powerful, fast, and an easy to use search engine ";
    homepage = https://docs.meilisearch.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
