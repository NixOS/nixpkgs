{ stdenv, fetchurl }:

let
  pname = "macchanger";
  version = "1.6.0";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "31534f138f1d21fa247be74ba6bef3fbfa47bbcd5033e99bd10c432fe58e51f7";
  };

  meta = {
    description = "A utility for viewing/manipulating the MAC address of network interfaces";
    maintainer = with stdenv.lib.maintainers; [ joachifm ];
    license = with stdenv.lib.licenses; gpl2Plus;
    homepage = "https://www.gnu.org/software/macchanger";
    platform = with stdenv.lib.platforms; linux;
  };
}
