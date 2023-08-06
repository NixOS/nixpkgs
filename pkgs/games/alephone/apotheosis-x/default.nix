{ alephone, requireFile }:

alephone.makeWrapper rec {
  pname = "apotheosis-x";
  version = "1.1";
  desktopName = "Marathon-Apotheosis-X";

  zip = requireFile {
    name = "Apotheosis_X_1.1.zip";
    url = "https://www.moddb.com/mods/apotheosis-x/downloads";
    sha256 = "sha256-4Y/RQQeN4VTpig8ZyxUpVHwzN8W8ciTBCkSzND8SMbs=";
  };

  sourceRoot = "Apotheosis X 1.1";

  meta = {
    description = "Total conversion for Marathon Infinity running on the Aleph One engine";
    homepage = "https://simplici7y.com/items/apotheosis-x-5";
  };
}
