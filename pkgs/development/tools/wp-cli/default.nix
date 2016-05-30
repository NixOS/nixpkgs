{ stdenv, lib, writeText, bash, fetchurl, php }:

let
  phpIni = writeText "wp-cli-php.ini" ''
    [Phar]
    phar.readonly = Off
  '';

in stdenv.mkDerivation rec {
  version = "0.23.1";
  name = "wp-cli-${version}";

  src = fetchurl {
    url = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "1sjai8gjsx6j82lsxq9m827bczp4ajnldk6ibj4krcisn9pjva5f";
  };

  propagatedBuildInputs = [ php ];

  buildCommand = ''
    mkdir -p $out/bin

    cat >$out/bin/wp <<EOF
    #! ${bash}/bin/bash -e
    exec ${php}/bin/php -c ${phpIni} -f ${src} "\$@"
    EOF

    chmod +x $out/bin/wp
  '';

  meta = {
    description = "A command line interface for WordPress";
    maintainers = [ stdenv.lib.maintainers.peterhoeg ];
    platforms = stdenv.lib.platforms.all;
    homepage = https://wp-cli.org;
    license = stdenv.lib.licenses.mit;
  };
}
