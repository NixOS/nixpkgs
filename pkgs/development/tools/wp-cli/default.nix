{ stdenv, lib, writeText, writeScript, fetchurl, php }:

let
  version = "1.0.0";
  name = "wp-cli-${version}";

  phpIni = writeText "wp-cli-php.ini" ''
    [Phar]
    phar.readonly = Off
  '';

  wpBin = writeScript "wp" ''
    #! ${stdenv.shell} -e
    exec ${php}/bin/php \
      -c ${phpIni} \
      -f ${src} "$@"
  '';

  src = fetchurl {
    url = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "06a80fz9na9arjdpmnislwr0121kkg11kxfqmac0axa9vkv9fjcp";
  };

in stdenv.mkDerivation rec {

  inherit name src;

  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${wpBin} $out/bin/wp
  '';

  meta = with stdenv.lib; {
    description = "A command line interface for WordPress";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
    homepage = https://wp-cli.org;
    license = licenses.mit;
  };
}
