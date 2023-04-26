{ lib
, mkKaemDerivation0
, src
, mescc-tools
, version
}:
mkKaemDerivation0 {
  inherit version src mescc-tools;
  pname = "mescc-tools-extra";
  script = ./build.kaem;

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
}
