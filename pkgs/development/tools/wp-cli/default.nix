{ stdenv, lib, fetchurl, php }:

let
  version = "1.2.1";

  bin  = "bin/wp";
  ini  = "etc/php/wp-cli.ini";
  phar = "share/wp-cli/wp-cli.phar";

  completion = fetchurl {
    url    = "https://raw.githubusercontent.com/wp-cli/wp-cli/v${version}/utils/wp-completion.bash";
    sha256 = "15d330x6d3fizrm6ckzmdknqg6wjlx5fr87bmkbd5s6a1ihs0g24";
  };

in stdenv.mkDerivation rec {
  name = "wp-cli-${version}";

  src = fetchurl {
    url    = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "1ds9nhm0akajwykblg0s131vki02k3rpf72a851r3wjw2qv116wz";
  };

  buildCommand = ''
    mkdir -p $out/bin $out/etc/php

    cat <<_EOF > $out/${bin}
    #! ${stdenv.shell} -eu
    exec ${lib.getBin php}/bin/php \\
      -c $out/${ini} \\
      -f $out/${phar} "\$@"
    _EOF
    chmod 755 $out/${bin}

    cat <<_EOF > $out/${ini}
    [Phar]
    phar.readonly = Off
    _EOF
    chmod 644 $out/${ini}

    install -Dm644 ${src}        $out/${phar}
    install -Dm644 ${completion} $out/share/bash-completion/completions/wp
  '';

  meta = with stdenv.lib; {
    description = "A command line interface for WordPress";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
    homepage = https://wp-cli.org;
    license = licenses.mit;
  };
}
