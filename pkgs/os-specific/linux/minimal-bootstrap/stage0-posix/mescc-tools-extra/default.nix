{ lib
, derivationWithMeta
, kaem-unwrapped
, mescc-tools
, src
, version
, platforms
, m2libcArch
, m2libcOS
}:
derivationWithMeta {
  inherit version src mescc-tools m2libcArch m2libcOS;
  pname = "mescc-tools-extra";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    ./build.kaem
  ];

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
  };
}
