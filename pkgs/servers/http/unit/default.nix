{ stdenv, fetchurl
, which
, python
, php71
, php72
, perl526
, perl
, perldevel
, ruby_2_3
, ruby_2_4
, ruby
, withSSL ? true, openssl ? null
, withIPv6 ? true
, withDebug ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "1.6";
  name = "unit-${version}";

  src = fetchurl {
    url = "https://unit.nginx.org/download/${name}.tar.gz";
    sha256 = "0lws5xpzkcmv0gc7vi8pgnymin02dq4gw0zb41jfzq0vbljxxl14";
  };

  buildInputs = [
    which
    python
    php71
    php72
    perl526
    perl
    perldevel
    ruby_2_3
    ruby_2_4
    ruby
  ] ++ optional withSSL openssl;

  configureFlags = [
    "--control=unix:/run/control.unit.sock"
    "--pid=/run/unit.pid"
  ] ++ optional withSSL     [ "--openssl" ]
    ++ optional (!withIPv6) [ "--no-ipv6" ]
    ++ optional withDebug   [ "--debug" ];

  postConfigure = ''
    ./configure python  --module=python    --config=${python}/bin/python-config  --lib-path=${python}/lib
    ./configure php     --module=php71     --config=${php71.dev}/bin/php-config  --lib-path=${php71}/lib
    ./configure php     --module=php72     --config=${php72.dev}/bin/php-config  --lib-path=${php72}/lib
    ./configure perl    --module=perl526   --perl=${perl526}/bin/perl
    ./configure perl    --module=perl      --perl=${perl}/bin/perl
    ./configure perl    --module=perl529   --perl=${perldevel}/bin/perl
    ./configure ruby    --module=ruby23    --ruby=${ruby_2_3}/bin/ruby
    ./configure ruby    --module=ruby24    --ruby=${ruby_2_4}/bin/ruby
    ./configure ruby    --module=ruby      --ruby=${ruby}/bin/ruby
  '';

  meta = {
    description = "Dynamic web and application server, designed to run applications in multiple languages.";
    homepage    = https://unit.nginx.org/;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
