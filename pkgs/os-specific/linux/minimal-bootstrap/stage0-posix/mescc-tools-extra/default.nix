{
  lib,
  derivationWithMeta,
  kaem-unwrapped,
  mescc-tools,
  src,
  version,
  platforms,
  m2libcArch,
  m2libcOS,
}:
derivationWithMeta {
  inherit
    version
    src
    mescc-tools
    m2libcArch
    m2libcOS
    ;
  pname = "mescc-tools-extra";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./build.kaem
  ];

  meta = {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    inherit platforms;
  };
}
