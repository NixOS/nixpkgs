{ lib
, fetchFromGitHub
, resholve
<<<<<<< HEAD
=======
, substituteAll
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bash
, coreutils
, goss
, which
}:

resholve.mkDerivation rec {
  pname = "dgoss";
<<<<<<< HEAD
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = "goss";
    rev = "refs/tags/v${version}";
    hash = "sha256-dpMTUBMEG5tDi7E6ZRg1KHqIj5qDlvwfwJEgq/5z7RE=";
=======
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "aelsabbahy";
    repo = "goss";
    rev = "v${version}";
    sha256 = "01ssc7rnnwpyhjv96qy8drsskghbfpyxpsahk8s62lh8pxygynhv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    sed -i '2i GOSS_PATH=${goss}/bin/goss' extras/dgoss/dgoss
    install -D extras/dgoss/dgoss $out/bin/dgoss
  '';

  solutions = {
    default = {
      scripts = [ "bin/dgoss" ];
      interpreter = "${bash}/bin/bash";
      inputs = [ coreutils which ];
      keep = {
        "$CONTAINER_RUNTIME" = true;
      };
    };
  };

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://github.com/goss-org/goss/blob/v${version}/extras/dgoss/README.md";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${version}";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual anthonyroussel ];
=======
    homepage = "https://github.com/aelsabbahy/goss/blob/v${version}/extras/dgoss/README.md";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
