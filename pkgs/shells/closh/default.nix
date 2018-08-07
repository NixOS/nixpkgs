{ stdenv, fetchurl, lumo, makeWrapper, yarn2nix }:

let yarnModules = yarn2nix.mkYarnModules {
      name="closh_modules";
      packageJSON=./package.json;
      yarnLock=./yarn.lock;
      yarnNix=./yarn.nix;
      yarnFlags = yarn2nix.defaultYarnFlags ++ [ "--build-from-source" ];
    };

in stdenv.mkDerivation rec {

  name = "closh";
  version = "0.2.2";
  
  src = fetchurl {
    url = "https://github.com/dundalek/closh/archive/v${version}.tar.gz";
    sha256 = "7f28298c134fd3bc845a297158e90a8c006cdc43cdfa8227ff8f678b0d592ea4";
  };

  buildInputs = [ makeWrapper ];

  nativeInputs = [ lumo ];
  
  installPhase = ''

      mkdir -p $out/bin
      cp -r ./src $out

      # https://github.com/dundalek/closh/blob/master/bin/closh.js
      makeWrapper ${lumo}/bin/lumo $out/bin/closh \
        --set NODE_PATH ${yarnModules}/node_modules \
        --add-flags \
          "--classpath $out/src \
           --cache \$HOME/.closh/cache/lumo \
           -m closh.main"                  
  '';

  meta = {
    description = "Bash-like shell based on Clojure";
    longDescription = ''
      Closh combines the best of traditional unix shells with the power of Clojure. It aims to be a modern alternative to bash.
    '';
    homepage = https://github.com/dundalek/closh;
    license = stdenv.lib.licenses.epl10;
    maintainers = [ stdenv.lib.maintainers.hlolli ];
    platforms = stdenv.lib.platforms.all;
  };
}



