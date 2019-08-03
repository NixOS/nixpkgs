{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "apparix-11-062";

  src = fetchurl {
    url = "https://micans.org/apparix/src/${name}.tar.gz";
    sha256 = "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://micans.org/apparix;
    description = "Add directory bookmarks, distant listing, and distant editing to the command line";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
