{ lib, callPackage, kurentoPackages, jdk }:

(callPackage ./kurento-module-creator {
  src = kurentoPackages.lib.fetchKurento {
    repo = "kurento-module-creator";
    sha256 = "sha256-GRyHyH4LH6W8nZU5upAl/m+aTrUMbb9QnCmCcklYi1I=";
  };
}).overrideAttrs (_: {
  postInstall = ''
    # Add a wrapper
    mkdir -p $out/bin
    echo '#!/bin/sh
    ${jdk}/bin/java -jar $out/share/java/kurento-module-creator-jar-with-dependencies.jar "$@"' > $out/bin/kurento-module-creator
    chmod +x $out/bin/kurento-module-creator

    # Move the cmake module
    mkdir -p $out/share/${kurentoPackages.lib.cmakeVersion}/Modules
    mv target/classes/FindKurentoModuleCreator.cmake $out/share/${kurentoPackages.lib.cmakeVersion}/Modules
  '';

  meta = with lib; {
    description = "Code auto-generation tool for Kurento Media Server modules";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
})
