{ stdenv, lib, fetchurl, writeScript, writeText, php }:

let
  name = "wp-cli-${version}";
  version = "1.3.0";

  src = fetchurl {
    url    = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${name}.phar";
    sha256 = "0q5d32jq7a6rba77sr1yyj6ib6x838hw14mm186ah1xxgnn7rnry";
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
    [Phar]
    phar.readonly = Off
  '';

in stdenv.mkDerivation rec {
  inherit name version;

  buildCommand = ''
    mkdir -p $out/{bin,share/bash-completion/completions}

    ln      -s     ${bin}        $out/bin/wp
    install -Dm644 ${completion} $out/share/bash-completion/completions/wp
  '';

  meta = with stdenv.lib; {
    description = "A command line interface for WordPress";
    homepage    = https://wp-cli.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
