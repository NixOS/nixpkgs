{ lib
, fetchFromGitHub
, resholvePackage
, substituteAll
, bash
, coreutils
, goss
, which
}:

resholvePackage rec {
  pname = "dgoss";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "aelsabbahy";
    repo = "goss";
    rev = "v${version}";
    sha256 = "1m5w5vwmc9knvaihk61848rlq7qgdyylzpcwi64z84rkw8qdnj6p";
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
      fake = {
        external = [ "docker" ];
      };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/aelsabbahy/goss/blob/v${version}/extras/dgoss/README.md";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual ];
  };
}
