{ stdenv, fetchFromGitHub, which
, withPython2 ? false, python2
, withPython3 ? true, python3, ncurses
, withPHP72 ? false, php72
, withPHP73 ? true, php73
, withPerl528 ? false, perl528
, withPerl530 ? true, perl530
, withPerldevel ? false, perldevel
, withRuby_2_4 ? false, ruby_2_4
, withRuby_2_5 ? false, ruby_2_5
, withRuby_2_6 ? true, ruby_2_6
, withRuby_2_7 ? true, ruby_2_7
, withSSL ? true, openssl ? null
, withIPv6 ? true
, withDebug ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.13.0";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "unit";
    rev = version;
    sha256 = "1b5il05isq5yvnx2qpnihsrmj0jliacvhrm58i87d48anwpv1k8q";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [ ]
    ++ optional withPython2 python2
    ++ optionals withPython3 [ python3 ncurses ]
    ++ optional withPHP72 php72
    ++ optional withPHP73 php73
    ++ optional withPerl528 perl528
    ++ optional withPerl530 perl530
    ++ optional withPerldevel perldevel
    ++ optional withRuby_2_4 ruby_2_4
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

  postConfigure = ''
    ${optionalString withPython2    "./configure python --module=python2  --config=${python2}/bin/python2-config  --lib-path=${python2}/lib"}
    ${optionalString withPython3    "./configure python --module=python3  --config=${python3}/bin/python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP72      "./configure php    --module=php72    --config=${php72.dev}/bin/php-config    --lib-path=${php72}/lib"}
    ${optionalString withPHP73      "./configure php    --module=php73    --config=${php73.dev}/bin/php-config    --lib-path=${php73}/lib"}
    ${optionalString withPerl528    "./configure perl   --module=perl528  --perl=${perl528}/bin/perl"}
    ${optionalString withPerl530    "./configure perl   --module=perl530  --perl=${perl530}/bin/perl"}
    ${optionalString withPerldevel  "./configure perl   --module=perldev  --perl=${perldevel}/bin/perl"}
    ${optionalString withRuby_2_4   "./configure ruby   --module=ruby24   --ruby=${ruby_2_4}/bin/ruby"}
    ${optionalString withRuby_2_5   "./configure ruby   --module=ruby25   --ruby=${ruby_2_5}/bin/ruby"}
    ${optionalString withRuby_2_6   "./configure ruby   --module=ruby26   --ruby=${ruby_2_6}/bin/ruby"}
    ${optionalString withRuby_2_7   "./configure ruby   --module=ruby27   --ruby=${ruby_2_7}/bin/ruby"}
  '';

  meta = {
    description = "Dynamic web and application server, designed to run applications in multiple languages.";
    homepage    = https://unit.nginx.org/;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
