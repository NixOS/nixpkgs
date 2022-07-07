{ stdenv
, lib
, fetchurl
, formats
, installShellFiles
, makeWrapper
, php
}:

let
  version = "2.6.0";

  completion = fetchurl {
    url = "https://raw.githubusercontent.com/wp-cli/wp-cli/v${version}/utils/wp-completion.bash";
    hash = "sha256-RDygYQzK6NLWrOug7EqnkpuH7Wz1T2Zq/tGNZjoYo5U=";
  };

  ini = (formats.ini { }).generate "php.ini" {
    PHP.memory_limit = -1; # no limit as composer uses a lot of memory
    Phar."phar.readonly" = "Off";
  };

in
stdenv.mkDerivation rec {
  pname = "wp-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/wp-cli/wp-cli/releases/download/v${version}/${pname}-${version}.phar";
    hash = "sha256-0WZSjKtgvIIpwGcp5wc4OPu6aNaytXRQTLAniDXIeIg=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildCommand = ''
    dir=$out/share/wp-cli
    install -Dm444 ${src}        $dir/wp-cli
    install -Dm444 ${ini}        $dir/php.ini
    installShellCompletion --bash --name wp ${completion}

    mkdir -p $out/bin
    makeWrapper ${lib.getBin php}/bin/php $out/bin/wp \
      --add-flags "-c $dir/php.ini" \
      --add-flags "-f $dir/wp-cli" \
      --add-flags "--"

    # this is a very basic run test
    $out/bin/wp --info >/dev/null
  '';

  meta = with lib; {
    description = "A command line interface for WordPress";
    homepage = "https://wp-cli.org";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
    mainProgram = "wp";
  };
}
