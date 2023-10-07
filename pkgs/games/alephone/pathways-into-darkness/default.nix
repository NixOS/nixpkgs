{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "pathways-into-darkness";
  desktopName = "Pathways-Into-Darkness";
  version = "1.1.1";

  zip = fetchurl {
    url = "http://simplici7y.com/version/file/1185/AOPID_v1.1.1.zip";
    sha256 = "0x83xjcw5n5s7sw8z6rb6zzhihjkjgk7x7ynnqq917dcklr7bz4g";
  };

  meta = {
    description = ''
      Port of the 1993 mac game "Pathways Into Darkness" by Bungie to the Aleph One engine'';
    homepage = "http://simplici7y.com/items/aleph-one-pathways-into-darkness";
  };

}
