{ lib
, stdenv
#, bundlerApp
#, bundlerUpdateScript
#, ruby
, bundlerEnv
, fetchFromGitHub
, rubyPackages_2_7
, ruby_2_7
, nixosTests
, nodejs-16_x
, yarn
}:

with rubyPackages_2_7;

let
  ruby = ruby_2_7;

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
  version = "1.15.1";

  passthru = {
    inherit rubyEnv extraPath;
    ruby = rubyEnv.wrappedRuby;
    tests = {
      nixos-test-passes = nixosTests.chatwoot;
    };
  };

  src = fetchFromGitHub {
    owner = "chatwoot";
    repo = "chatwoot";
    rev = "v${version}";
    sha256 = "dRJFqhsSLTSMnTHgdN7ZTzc7plCsqLlLRRqpwXdxmkg=";
    fetchSubmodules = true;
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
