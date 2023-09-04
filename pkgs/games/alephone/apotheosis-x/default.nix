{ alephone, fetchEris }:

alephone.makeWrapper rec {
  pname = "apotheosis-x";
  version = "1.1";
  desktopName = "Marathon-Apotheosis-X";

  zip = fetchEris {
    name = "Apotheosis_X_1.1.zip";
    urn = "urn:eris:B4BDOXNCKXBLVZA5C6MR7YMOFLP5YXN4X7TRVO6N2H6GRM2WZTNTYVKPC4FBMHQHPATPRQWJZVETTN27VWBT23GPEVD262RKPZASE53X3Q";
    erisStores = [ "coap+tcp://eris.bidstonobservatory.org:5683" ];
    hash = "sha256-4Y/RQQeN4VTpig8ZyxUpVHwzN8W8ciTBCkSzND8SMbs=";
    alternateInstructions = "Game-data might be found at https://www.moddb.com/mods/apotheosis-x/downloads/apotheosis-x-v11.";
  };

  sourceRoot = "Apotheosis X 1.1";

  meta = {
    description = "Total conversion for Marathon Infinity running on the Aleph One engine";
    homepage = "https://simplici7y.com/items/apotheosis-x-5";
  };
}
