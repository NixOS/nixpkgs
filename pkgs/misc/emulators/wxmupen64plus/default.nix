{stdenv, fetchurl, python, wxGTK29, mupen64plus, SDL, libX11, mesa}:

stdenv.mkDerivation {
  name = "wxmupen64plus-0.3";
  src = fetchurl {
    url = "https://bitbucket.org/auria/wxmupen64plus/get/0.3.tar.bz2";
    sha256 = "1mnxi4k011dd300k35li2p6x4wccwi6im21qz8dkznnz397ps67c";
  };

  buildInputs = [ python wxGTK29 SDL libX11 mesa ];

  configurePhase = ''
    tar xf ${mupen64plus.src}
    APIDIR=$(eval echo `pwd`/mupen64plus*/source/mupen64plus-core/src/api)
    export CXXFLAGS="-I${libX11.dev}/include/X11 -DLIBDIR=\\\"${mupen64plus}/lib/\\\""
    export LDFLAGS="-lwx_gtk2u_adv-2.9"
    python waf configure --mupenapi=$APIDIR --wxconfig=`type -P wx-config` --prefix=$out
  '';

  buildPhase = "python waf";
  installPhase = "python waf install";

  meta = {
    description = "GUI for the Mupen64Plus 2.0 emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = https://bitbucket.org/auria/wxmupen64plus/wiki/Home;
    broken = true;
  };
}
