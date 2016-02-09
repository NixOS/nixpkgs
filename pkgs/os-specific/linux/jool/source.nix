{ fetchzip }:

rec {
  version = "3.4.2";
  src = fetchzip {
    url = "https://www.jool.mx/download/Jool-${version}.zip";
    sha256 = "1qv7wwipylb76n8m8vphbf9rgxrryb42dsyw6mm43zjc9knsz7r0";
  };
}
