{ lib
, derivationWithMeta
, kaem-unwrapped
, mescc-tools
, src
, version
}:
derivationWithMeta {
  inherit version src mescc-tools;
  pname = "mescc-tools-extra";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./build.kaem
  ];

  ARCH = "x86";
  OPERATING_SYSTEM = "linux";

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = [ "i686-linux" ];
  };
}
