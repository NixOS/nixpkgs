{ stdenv, lib, fetchurl, writeScript, writeText, php }:

let
  version = "2.0.1";

  completion = fetchurl {
    url    = "https://raw.githubusercontent.com/wp-cli/wp-cli/v${version}/utils/wp-completion.bash";
    sha256 = "15d330x6d3fizrm6ckzmdknqg6wjlx5fr87bmkbd5s6a1ihs0g24";
  };

in stdenv.mkDerivation rec {
  name = "wp-cli-${version}";
  inherit version;

  src = fetchurl {
    url    = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "05lbay4c0477465vv4h8d2j94pk3haz1a7f0ncb127fvxz3a2pcg";
  };

  buildCommand = ''
    dir=$out/share/wp-cli
    mkdir -p $out/bin $dir

    cat <<_EOF > $out/bin/wp
#!${stdenv.shell}

set -euo pipefail

exec ${lib.getBin php}/bin/php \\
  -c $dir/php.ini \\
  -f $dir/wp-cli -- "\$@"
_EOF
    chmod 0755 $out/bin/wp

    cat <<_EOF > $dir/php.ini
[PHP]
memory_limit = -1 ; no limit as composer uses a lot of memory

[Phar]
phar.readonly = Off
_EOF

    install -Dm644 ${src}        $dir/wp-cli
    install -Dm644 ${completion} $out/share/bash-completion/completions/wp

    # this is a very basic run test
    $out/bin/wp --info
  '';

  meta = with stdenv.lib; {
    description = "A command line interface for WordPress";
    homepage    = https://wp-cli.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
