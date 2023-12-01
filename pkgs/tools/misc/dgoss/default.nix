{ lib
, fetchFromGitHub
, resholve
, bash
, coreutils
, goss
, which
}:

resholve.mkDerivation rec {
  pname = "dgoss";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "goss-org";
    repo = "goss";
    rev = "refs/tags/v${version}";
    hash = "sha256-FDn1OETkYIpMenk8QAAHvfNZcSzqGl5xrD0fAZPVmRM=";
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
    homepage = "https://github.com/goss-org/goss/blob/v${version}/extras/dgoss/README.md";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${version}";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual anthonyroussel ];
    mainProgram = "dgoss";
  };
}
