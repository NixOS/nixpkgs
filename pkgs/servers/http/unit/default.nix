{ lib, stdenv, fetchFromGitHub, nixosTests, which
, pcre2
, withPython2 ? false, python2
, withPython3 ? true, python3, ncurses
, withPHP74 ? false, php74
, withPHP80 ? true, php80
, withPerl532 ? false, perl532
, withPerl534 ? true, perl534
, withPerldevel ? false, perldevel
, withRuby_2_7 ? false, ruby_2_7
, withSSL ? true, openssl ? null
, withIPv6 ? true
, withDebug ? false
}:

with lib;

let
  phpConfig = {
    embedSupport = true;
    apxs2Support = false;
    systemdSupport = false;
    phpdbgSupport = false;
    cgiSupport = false;
    fpmSupport = false;
  };

  php74-unit = php74.override phpConfig;
  php80-unit = php80.override phpConfig;

in stdenv.mkDerivation rec {
  version = "1.25.0";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = pname;
    rev = version;
    sha256 = "sha256-8Xv7YTvwuI0evBO1Te4oI1IoJ0AnK8OVZoZTYtfYKfw=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [ pcre2.dev ]
    ++ optional withPython2 python2
    ++ optionals withPython3 [ python3 ncurses ]
    ++ optional withPHP74 php74-unit
    ++ optional withPHP80 php80-unit
    ++ optional withPerl532 perl532
    ++ optional withPerl534 perl534
    ++ optional withPerldevel perldevel
    ++ optional withRuby_2_7 ruby_2_7
    ++ optional withSSL openssl;

  configureFlags = [
    "--control=unix:/run/unit/control.unit.sock"
    "--pid=/run/unit/unit.pid"
    "--user=unit"
    "--group=unit"
  ] ++ optional withSSL     "--openssl"
    ++ optional (!withIPv6) "--no-ipv6"
    ++ optional withDebug   "--debug";

  # Optionally add the PHP derivations used so they can be addressed in the configs
  usedPhp74 = optionals withPHP74 php74-unit;
  usedPhp80 = optionals withPHP80 php80-unit;

  postConfigure = ''
    ${optionalString withPython2    "./configure python --module=python2  --config=python2-config  --lib-path=${python2}/lib"}
    ${optionalString withPython3    "./configure python --module=python3  --config=python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP74      "./configure php    --module=php74    --config=${php74-unit.unwrapped.dev}/bin/php-config --lib-path=${php74-unit}/lib"}
    ${optionalString withPHP80      "./configure php    --module=php80    --config=${php80-unit.unwrapped.dev}/bin/php-config --lib-path=${php80-unit}/lib"}
    ${optionalString withPerl532    "./configure perl   --module=perl532  --perl=${perl532}/bin/perl"}
    ${optionalString withPerl534    "./configure perl   --module=perl534  --perl=${perl534}/bin/perl"}
    ${optionalString withPerldevel  "./configure perl   --module=perldev  --perl=${perldevel}/bin/perl"}
    ${optionalString withRuby_2_7   "./configure ruby   --module=ruby27   --ruby=${ruby_2_7}/bin/ruby"}
  '';

  passthru.tests.unit-php = nixosTests.unit-php;

  meta = {
    description = "Dynamic web and application server, designed to run applications in multiple languages";
    homepage    = "https://unit.nginx.org/";
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
