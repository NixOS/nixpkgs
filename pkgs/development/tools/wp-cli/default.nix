{ stdenv, lib, fetchurl, writeScript, writeText, php }:

let
  name = "wp-cli-${version}";
  version = "2.0.0";

  src = fetchurl {
    url    = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "1s8pv8vdjwiwknpwsxc59l1zxc2np7nrp6bjd0s8jwsrv5fgjzsp";
  };

  completion = fetchurl {
    url    = "https://raw.githubusercontent.com/wp-cli/wp-cli/v${version}/utils/wp-completion.bash";
    sha256 = "15d330x6d3fizrm6ckzmdknqg6wjlx5fr87bmkbd5s6a1ihs0g24";
  };

  bin = writeScript "wp" ''
    #! ${stdenv.shell}

    set -euo pipefail

    exec ${lib.getBin php}/bin/php \
      -c ${ini} \
      -f ${src} -- "$@"
  '';

  ini = writeText "wp-cli.ini" ''
    [PHP]
    memory_limit = -1 ; no limit as composer uses a lot of memory

    [Phar]
    phar.readonly = Off
  '';

in stdenv.mkDerivation rec {
  inherit name version;

  buildCommand = ''
    install -Dm755 ${bin}        $out/bin/wp
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
