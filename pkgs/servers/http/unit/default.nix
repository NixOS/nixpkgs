{ lib, stdenv, fetchFromGitHub, nixosTests, which
, pcre2
, withPython3 ? true, python3, ncurses
, withPHP80 ? false, php80
, withPHP81 ? true, php81
, withPerl532 ? false, perl532
, withPerl534 ? true, perl534
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

  php80-unit = php80.override phpConfig;
  php81-unit = php81.override phpConfig;

in stdenv.mkDerivation rec {
  version = "1.27.0";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = pname;
    rev = version;
    sha256 = "sha256-H/WIrCyocEO/HZfVMyI9IwD565JsUIzC8n1qUYmCvWc=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [ pcre2.dev ]
    ++ optionals withPython3 [ python3 ncurses ]
    ++ optional withPHP80 php80-unit
    ++ optional withPHP81 php81-unit
    ++ optional withPerl532 perl532
    ++ optional withPerl534 perl534
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
  usedPhp80 = optionals withPHP80 php80-unit;
  usedPhp81 = optionals withPHP81 php81-unit;

  postConfigure = ''
    ${optionalString withPython3    "./configure python --module=python3  --config=python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP80      "./configure php    --module=php80    --config=${php80-unit.unwrapped.dev}/bin/php-config --lib-path=${php80-unit}/lib"}
    ${optionalString withPHP81      "./configure php    --module=php81    --config=${php81-unit.unwrapped.dev}/bin/php-config --lib-path=${php81-unit}/lib"}
    ${optionalString withPerl532    "./configure perl   --module=perl532  --perl=${perl532}/bin/perl"}
    ${optionalString withPerl534    "./configure perl   --module=perl534  --perl=${perl534}/bin/perl"}
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
