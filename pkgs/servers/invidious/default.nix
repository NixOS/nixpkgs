{ lib, crystal, fetchgit, git, libxml2, sqlite, openssl_1_0_2, yaml2json }:
crystal.buildCrystalPackage rec {
  pname = "invidious";
  version = "0.19.1";

  src = fetchgit {
    url = "https://github.com/omarroth/invidious.git";
    rev = version;
    sha256 = "1z3s9qq6bzzgwjyijffy46cby2f8n03461a0ykpwsjhlyd9ls8bf";
    # Needed for extracting commit history, as well as for git version embedding
    deepClone = true;
  };

  nativeBuildInputs = [ git ];

  postPatch = ''
    # Patch the assets and locales paths to be absolute
    sed -i src/invidious.cr \
      -e 's|public_folder "assets"|public_folder "${placeholder "out"}/share/invidious/assets"|g'
    sed -i src/invidious/helpers/i18n.cr \
      -e 's|File.read("locales/|File.read("${placeholder "out"}/share/invidious/locales/|g'

    # Make sql script paths absolute
    sed -i config/migrate-scripts/* src/invidious/helpers/helpers.cr \
      -e 's|config/sql|${placeholder "out"}/share/invidious/config/sql|g'

    # https://github.com/omarroth/invidious/pull/729
    sed -i config/migrate-scripts/migrate-db-3646395.sh \
      -e 's|psql invidious <|psql invidious kemal <|g'
  '';

  shardsFile = ./shards.nix;
  crystalBinaries.invidious.src = "src/invidious.cr";

  buildInputs = [ libxml2 sqlite openssl_1_0_2 ];

  postInstall = ''
    mkdir -p $out/nix-support/invidious $out/share/invidious/config

    # Extract the list of past commits in chronological order, such that when
    # migrating, we know which migration scripts need to be run, since migration
    # scripts are named after the commit they introduced the change
    # necessitating it
    git rev-list --abbrev-commit --reverse HEAD > $out/nix-support/invidious/pastcommits

    # Copy static parts
    cp -r assets locales $out/share/invidious
    cp -r config/{sql,migrate-scripts} $out/share/invidious/config

    chmod +x $out/share/invidious/config/migrate-scripts/*
  '';

  meta = with lib; {
    description = "Invidious is an alternative front-end to YouTube";
    homepage = "https://invidio.us/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ infinisil ];
  };
}
