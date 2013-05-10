{ stdenv, fetchurl, darwinX11AndOpenGL }:

assert stdenv.isDarwin;

stdenv.mkDerivation rec {
  name = "wxMac-${version}";
  version = "2.8.12";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/wxwindows/${version}/${name}.tar.gz";
    sha256 = "11qzcbx5kpl22jirfjbjzaax488r1ar2qiw8q7yz7r45b2y1x7gx";
  };

  buildInputs = [ darwinX11AndOpenGL ];
  preConfigure = ''
    export arch_flags="-arch i386"
  '';
  configureFlags = ''
    --enable-unicode --enable-debug --disable-shared
    --with-expat
    --enable-display
    --with-opengl
    --with-libjpeg
    --with-libtiff
    --with-libpng
    --with-zlib
    --enable-dnd
    --enable-clipboard
    --enable-webkit
    --enable-svg
    --enable-std_string
    --with-osx_carbon
    --with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk
    --with-macosx-version-min=10.6
  '';

  meta = {
    description = "Cross-Platform GUI Library";
    homepage = "http://www.wxwidgets.org";
    maintainers = [ stdenv.lib.maintainers.garbas ];
    license = "wxWindows Licence";
    platforms = stdenv.lib.platforms.darwin;
  };

}
