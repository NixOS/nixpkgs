{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.5";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1b91pbdarnfmbhid8aa2f50k0fln8n7pg62782b4y0jlzvaljqi2";
  };

  meta = with stdenv.lib; {
    description = "A command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = https://www.gnu.org/software/datamash/;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub vrthra ];
  };

}
