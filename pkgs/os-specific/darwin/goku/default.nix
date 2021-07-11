{ lib, stdenv, pkgs, fetchFromGitHub, graalvm, clojure, joker,
  watchexec, runtimeShell, Foundation, zlib }:

let cljdeps = import ./goku.deps.nix { inherit pkgs; };
    classp = cljdeps.makeClasspaths {};
    clojureGraal = clojure.override { jdk = graalvm; };

in stdenv.mkDerivation rec {
  pname = "goku";
  version = "0.3.11";

  buildInputs = [ clojureGraal Foundation zlib ];

  src = fetchFromGitHub {
    owner = "yqrashawn";
    repo = "GokuRakuJoudo";
    rev = "v${version}";
    sha256 = "0j9lk194a4fva866c3q6nhblcb9zfl6nz0gb6zymnsalkp56pfzn";
  };

  patchPhase = ''
    substituteInPlace src/karabiner_configurator/core.clj \
      --replace 'shell/sh joker-bin' 'shell/sh "${joker}/bin/joker"'
  '';

  buildPhase = ''
    HOME=$(pwd) \
    clojure \
      -Scp 'src:${classp}' \
      -m clj.native-image karabiner-configurator.core \
      --initialize-at-build-time \
      --report-unsupported-elements-at-runtime \
      -H:-CheckToolchain -H:+ReportExceptionStackTraces
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp karabiner_configurator.core $out/bin/goku
    # https://github.com/yqrashawn/GokuRakuJoudo/blob/a9016fe1ffd700365b1929a87a15c90132903640/.github/workflows/build-and-release.yaml#L34-L38
    touch $out/bin/gokuw
    echo "#!${runtimeShell}" >> $out/bin/gokuw
    echo '${watchexec}/bin/watchexec -r -w `[[ -z $GOKU_EDN_CONFIG_FILE ]] && echo ~/.config/karabiner.edn || echo $GOKU_EDN_CONFIG_FILE`' \
          $out/bin/goku >> $out/bin/gokuw
    chmod +x $out/bin/gokuw
  '';

  meta = with lib; {
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = licenses.gpl3;
    maintainers = [ maintainers.nikitavoloboev maintainers.hlolli ];
    platforms = platforms.darwin;
  };
}
