{ lib, crystal, fetchgit, git, libxml2, sqlite, openssl_1_0_2, librsvg, writeText }:
crystal.buildCrystalPackage rec {
  pname = "invidious";
  version = "0.20.1";

  src = fetchgit {
    url = "https://github.com/omarroth/invidious.git";
    rev = version;
    sha256 = "17il5mmmz5960aask63wv8vyy3hkyrq30ak5vzdql9pwcmdf6zs8";
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

    substituteInPlace src/invidious/users.cr \
      --replace 'Process.run(%(rsvg-convert' 'Process.run(%(${lib.getBin librsvg}/bin/rsvg-convert'
  '';

  shardsFile = ./shards.nix;
  crystalBinaries.invidious.src = "src/invidious.cr";
  crystalBinaries.invidious.options = [ ];

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
