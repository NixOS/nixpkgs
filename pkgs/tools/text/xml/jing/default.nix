{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation {
  name = "jing-20091111";
  builder = ./unzip-builder.sh;

  src = fetchurl {
    url = https://jing-trang.googlecode.com/files/jing-20091111.zip;
    sha256 = "134h2r22r64v5yk4v8mhl6r893dlw5vzx9daf2sj2mbbma004sap";
  };

  inherit unzip jre;

  meta = with stdenv.lib; {
    description = "A RELAX NG validator in Java";
    # The homepage is www.thaiopensource.com, but it links to googlecode.com
    # for downloads and call it the "project site".
    homepage = http://www.thaiopensource.com/relaxng/jing.html;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
