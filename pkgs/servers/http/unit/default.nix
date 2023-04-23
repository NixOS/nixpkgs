{ lib, stdenv, fetchFromGitHub, nixosTests, which
, pcre2
, withPython3 ? true, python3, ncurses
, withPHP81 ? true, php81
, withPHP82 ? false, php82
, withPerl534 ? false, perl534
, withPerl536 ? true, perl536
, withPerldevel ? false, perldevel
, withRuby_2_7 ? true, ruby_2_7
, withRuby_3_0 ? false, ruby_3_0
, withRuby_3_1 ? false, ruby_3_1
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

  php81-unit = php81.override phpConfig;
  php82-unit = php82.override phpConfig;

in stdenv.mkDerivation rec {
  version = "1.29.1";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = pname;
    rev = version;
    sha256 = "sha256-Jk/rzPJq1FWWTe31Fa2Ah+MoWP5mh6XNSmiYIY42vvk=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [ pcre2.dev ]
    ++ optionals withPython3 [ python3 ncurses ]
    ++ optional withPHP81 php81-unit
    ++ optional withPHP82 php82-unit
    ++ optional withPerl534 perl534
    ++ optional withPerl536 perl536
    ++ optional withPerldevel perldevel
    ++ optional withRuby_2_7 ruby_2_7
    ++ optional withRuby_3_0 ruby_3_0
    ++ optional withRuby_3_1 ruby_3_1
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
  usedPhp81 = optionals withPHP81 php81-unit;

  postConfigure = ''
    ${optionalString withPython3    "./configure python --module=python3  --config=python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP81      "./configure php    --module=php81    --config=${php81-unit.unwrapped.dev}/bin/php-config --lib-path=${php81-unit}/lib"}
    ${optionalString withPHP82      "./configure php    --module=php81    --config=${php82-unit.unwrapped.dev}/bin/php-config --lib-path=${php82-unit}/lib"}
    ${optionalString withPerl534    "./configure perl   --module=perl534  --perl=${perl534}/bin/perl"}
    ${optionalString withPerl536    "./configure perl   --module=perl536  --perl=${perl536}/bin/perl"}
    ${optionalString withPerldevel  "./configure perl   --module=perldev  --perl=${perldevel}/bin/perl"}
    ${optionalString withRuby_2_7   "./configure ruby   --module=ruby27   --ruby=${ruby_2_7}/bin/ruby"}
    ${optionalString withRuby_3_0   "./configure ruby   --module=ruby30   --ruby=${ruby_3_0}/bin/ruby"}
    ${optionalString withRuby_3_1   "./configure ruby   --module=ruby31   --ruby=${ruby_3_1}/bin/ruby"}
  '';

  postInstall = ''
    rmdir $out/state
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
