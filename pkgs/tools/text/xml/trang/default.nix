{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation {
  name = "trang-20091111";
  builder = ./builder.sh;

  src = fetchurl {
    url = https://jing-trang.googlecode.com/files/trang-20091111.zip;
    sha256 = "16551j63n2y3w9lc7krjazddsab7xvdymbss4rdvx3liz4sg18yq";
  };

  inherit jre;

  buildInputs = [ unzip ];

  meta = with stdenv.lib; {
    description = "Multi-format schema converter based on RELAX NG";
    # The homepage is www.thaiopensource.com, but it links to googlecode.com
    # for downloads and call it the "project site".
    homepage = http://www.thaiopensource.com/relaxng/trang.html;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
