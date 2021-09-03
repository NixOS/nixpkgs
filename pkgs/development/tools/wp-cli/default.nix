{ stdenv, lib, fetchurl, writeText, php, makeWrapper }:
let
  version = "2.5.0";

  completion = fetchurl {
    url = "https://raw.githubusercontent.com/wp-cli/wp-cli/v${version}/utils/wp-completion.bash";
    sha256 = "sha256-RDygYQzK6NLWrOug7EqnkpuH7Wz1T2Zq/tGNZjoYo5U=";
  };

  ini = writeText "php.ini" ''
    [PHP]
    memory_limit = -1 ; no limit as composer uses a lot of memory

    [Phar]
    phar.readonly = Off
  '';
in
stdenv.mkDerivation rec {
  pname = "wp-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${pname}-${version}.phar";
    sha256 = "sha256-vghT6fRD84SFZgcIcdNE6K2B6x4V0V3PkyS0p14nJ4k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    dir=$out/share/wp-cli
    mkdir -p $out/bin $dir

    install -Dm444 ${src}        $dir/wp-cli
    install -Dm444 ${ini}        $dir/php.ini
    install -Dm444 ${completion} $out/share/bash-completion/completions/wp

    makeWrapper ${lib.getBin php}/bin/php $out/bin/wp \
      --add-flags "-c $dir/php.ini" \
      --add-flags "-f $dir/wp-cli"

    # this is a very basic run test
    $out/bin/wp --info >/dev/null
  '';

  meta = with lib; {
    description = "A command line interface for WordPress";
    homepage = "https://wp-cli.org";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
