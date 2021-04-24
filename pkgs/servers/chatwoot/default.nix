{ lib
, stdenv
#, bundlerApp
#, bundlerUpdateScript
#, ruby
, bundlerEnv
, fetchFromGitHub
, rubyPackages_3_0
, ruby_3_0
, nixosTests
, nodejs-16_x
, yarn
, fetchYarnDeps
, fixup_yarn_lock
, git
, cacert
}:

with rubyPackages_3_0;

let
  ruby = ruby_3_0;

  rubyEnv = bundlerEnv {
    name = "chatwoot-env";
    inherit ruby;
    gemdir  = ./.;
  };

  extraPath = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
    ruby
    nodejs-16_x
    yarn
  ];

  /*
  apt update

  apt install -y \
  	git software-properties-common imagemagick libpq-dev \
      libxml2-dev libxslt1-dev file g++ gcc autoconf build-essential \
      libssl-dev libyaml-dev libreadline-dev gnupg2 nginx redis-server \
      redis-tools postgresql postgresql-contrib certbot \
      python3-certbot-nginx nodejs yarn patch ruby-dev zlib1g-dev liblzma-dev \
      libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev nginx-full

  */
in
stdenv.mkDerivation rec {
  pname = "chatwoot";
  # version = "1.21.1";
  version = "unstable-2021-01-11";

  passthru = {
    inherit rubyEnv extraPath;
    ruby = rubyEnv.wrappedRuby;
    tests = {
      nixos-test-passes = nixosTests.chatwoot;
    };
  };

  /* yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = lib.fakeSha256;
  };

  assets = stdenv.mkDerivation {
    pname = "chatwoot-assets";
    inherit version src;

    nativeBuildInputs = [ rubyEnv.wrappedRuby rubyEnv.bundler nodejs-16_x yarn git cacert ];

    # Since version 12.6.0, the rake tasks need the location of git,
    # so we have to apply the location patches here too.
    # patches = [ ./remove-hardcoded-locations.patch ];
    # One of the patches uses this variable - if it's unset, execution
    # of rake tasks fails.
    # GITLAB_LOG_PATH = "log";
    # FOSS_ONLY = !gitlabEnterprise;

    configurePhase = ''
      runHook preConfigure

      # Some rake tasks try to run yarn automatically, which won't work
      # rm lib/tasks/yarn.rake

      # The rake tasks won't run without a basic configuration in place
      # mv config/database.yml.env config/database.yml
      # mv config/gitlab.yml.example config/gitlab.yml

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive

      patchShebangs node_modules/

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bundle exec rake rake:assets:precompile RAILS_ENV=production NODE_ENV=production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv public/assets $out

      runHook postInstall
    '';
  }; */

  src = fetchFromGitHub {
    # owner = "chatwoot";
    # repo = "chatwoot";
    owner = "mkg20001";
    repo = "chatwoot";
    rev = "a0656b89c1085dbc06522afdd45e2850770ed2f5";
    sha256 = "GyuGOumIk1U4RM9or2fKa6wfA2drIChlBiwDPN9Mj/M=";
    fetchSubmodules = true;
    # rev = "v${version}";
  };

  buildInputs = extraPath;

  /* buildPhase = ''
    # TODO: fix this
    rake assets:precompile RAILS_ENV=production
  ''; */

  /*
  ./vendor/assets/stylesheets/.keep
  ./vendor/assets/javascripts/.keep
  ./vendor/db/.keep
  ./spec/models/.keep
  ./spec/fixtures/.keep
  ./spec/fixtures/files/.keep
  ./spec/controllers/.keep
  ./spec/mailers/.keep
  ./spec/integration/.keep
  ./tmp/.keep
  ./log/.keep
  ./lib/assets/.keep
  ./lib/tasks/.keep
  ./app/assets/images/.keep
  ./app/models/concerns/.keep
  ./app/controllers/concerns/.keep
  */

  installPhase = ''
    lnk() {
      LOCAL="$out/$1"
      TARGET="$2"
      if [ -z "$TARGET" ]; then
        TARGET="/run/chatwoot/$1"
      fi
      rm -rf "$LOCAL"
      ln -s "$TARGET" "$LOCAL"
    }
    cp -r . $out
    # ln -sf ''${assets} $out/public/assets
    # rm -rf $out/log
    lnk log /var/log/chatwoot
    lnk tmp /tmp
    # ln -sf /run/chatwoot/uploads $out/public/uploads
    # ln -sf /run/chatwoot/config $out/config
  '';

  meta = with lib; {
    inherit (ruby.meta) platforms;

    description = "Customer engagement suite - an open-source alternative to Intercom, Zendesk, Salesforce Service Cloud etc.";
    homepage    = "https://github.com/chatwoot/chatwoot";
    license     = with licenses; mit;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
