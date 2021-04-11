{ stdenv, lib, yarn, mkYarnPackage, mobilizon, ncurses, imagemagick }:

mkYarnPackage rec {

  src = stdenv.mkDerivation {
    name = "mobilizon-js-src";

    src = "${mobilizon.src}/js";

    phases = [ "unpackPhase" "patchPhase" "installPhase" ];

    patches = [
      # Due to the unsupported "resolution" parameter of "package.json"
      ./fix-yarn-lock.patch
      # I'm not sure why this doesn't work, but this is just the Vue config
      # setting a lower limit on memory usage, it should not affect the output
      ./fix-vue-config.patch
    ];

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -a . $out/

      runHook postInstall
    '';
  };

  packageJSON = "${src}/package.json";
  yarnLock = "${src}/yarn.lock";

  buildPhase = ''
    runHook preBuild

    # Tests cannot find the functions of the testing framework
    rm -r ./deps/mobilizon/tests
    yarn run build

    runHook postBuild
  '';

  nativeBuildInputs = [ ncurses imagemagick ];

  meta = with lib; {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ minijackson ];
  };
}
