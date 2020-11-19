{ stdenv, fetchFromGitHub, nixosTests, which
, withPython2 ? false, python2
, withPython3 ? true, python3, ncurses
, withPHP73 ? false, php73
, withPHP74 ? true, php74
, withPerl530 ? false, perl530
, withPerl532 ? true, perl532
, withPerldevel ? false, perldevel
, withRuby_2_5 ? false, ruby_2_5
, withRuby_2_6 ? true, ruby_2_6
, withRuby_2_7 ? false, ruby_2_7
, withSSL ? true, openssl ? null
, withIPv6 ? true
, withDebug ? false
}:

with stdenv.lib;

let
  phpConfig = {
    embedSupport = true;
    apxs2Support = false;
    systemdSupport = false;
    phpdbgSupport = false;
    cgiSupport = false;
    fpmSupport = false;
  };

  php73-unit = php73.override phpConfig;
  php74-unit = php74.override phpConfig;

in stdenv.mkDerivation rec {
  version = "1.20.0";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "unit";
    rev = version;
    sha256 = "1qmcz01ifmd80qgpvf1y8nhad6yk56772xdhqvwfxn3mdjfqvcs8";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [ ]
    ++ optional withPython2 python2
    ++ optionals withPython3 [ python3 ncurses ]
    ++ optional withPHP73 php73-unit
    ++ optional withPHP74 php74-unit
    ++ optional withPerl530 perl530
    ++ optional withPerl532 perl532
    ++ optional withPerldevel perldevel
    ++ optional withRuby_2_5 ruby_2_5
    ++ optional withRuby_2_6 ruby_2_6
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
  usedPhp73 = optionals withPHP73 php73-unit;
  usedPhp74 = optionals withPHP74 php74-unit;

  postConfigure = ''
    ${optionalString withPython2    "./configure python --module=python2  --config=python2-config  --lib-path=${python2}/lib"}
    ${optionalString withPython3    "./configure python --module=python3  --config=python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP73      "./configure php    --module=php73    --config=${php73-unit.unwrapped.dev}/bin/php-config --lib-path=${php73-unit}/lib"}
    ${optionalString withPHP74      "./configure php    --module=php74    --config=${php74-unit.unwrapped.dev}/bin/php-config --lib-path=${php74-unit}/lib"}
    ${optionalString withPerl530    "./configure perl   --module=perl530  --perl=${perl530}/bin/perl"}
    ${optionalString withPerl532    "./configure perl   --module=perl532  --perl=${perl532}/bin/perl"}
    ${optionalString withPerldevel  "./configure perl   --module=perldev  --perl=${perldevel}/bin/perl"}
    ${optionalString withRuby_2_5   "./configure ruby   --module=ruby25   --ruby=${ruby_2_5}/bin/ruby"}
    ${optionalString withRuby_2_6   "./configure ruby   --module=ruby26   --ruby=${ruby_2_6}/bin/ruby"}
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
