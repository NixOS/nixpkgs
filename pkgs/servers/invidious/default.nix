{ lib, crystal, fetchgit, git, libxml2, sqlite, openssl_1_0_2, imagemagick7, writeText }:
crystal.buildCrystalPackage rec {
  pname = "invidious";
  version = "0.19.1";

  src = fetchgit {
    url = "https://github.com/omarroth/invidious.git";
    rev = version;
    sha256 = "1y062ngy0wi6aa4bnz68c6jniy6c6bmz6lcvh40gz7c85rwqm23g";
    # Needed for extracting commit history, as well as for git version embedding
    deepClone = true;
  };

  nativeBuildInputs = [ git ];

  patches = [ (writeText "patch" ''
    diff --git a/src/invidious.cr b/src/invidious.cr
    index 315363d..d0cda68 100644
    --- a/src/invidious.cr
    +++ b/src/invidious.cr
    @@ -5202,4 +5202,5 @@ add_context_storage_type(Preferences)
     add_context_storage_type(User)

     Kemal.config.logger = logger
    +Kemal.config.port = config.external_port || 3000
     Kemal.run
    diff --git a/src/invidious/helpers/utils.cr b/src/invidious/helpers/utils.cr
    index 69aae83..91e1c14 100644
    --- a/src/invidious/helpers/utils.cr
    +++ b/src/invidious/helpers/utils.cr
    @@ -209,7 +209,7 @@ end

     def make_host_url(config, kemal_config)
       ssl = config.https_only || kemal_config.ssl
    -  port = config.external_port || kemal_config.port
    +  port = kemal_config.port

       if ssl
         scheme = "https://"
  '') ];

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

    # Needed for captcha to work. Note that imagemagick7_light wouldn't work
    substituteInPlace src/invidious/users.cr \
      --replace 'Process.run(%(convert' 'Process.run(%(${imagemagick7}/bin/convert'
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
