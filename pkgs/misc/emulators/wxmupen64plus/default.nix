{ stdenv, fetchurl, python, wxGTK29, mupen64plus, SDL, libX11, libGLU_combined
, wafHook }:

stdenv.mkDerivation {
  name = "wxmupen64plus-0.3";
  src = fetchurl {
    url = "https://bitbucket.org/auria/wxmupen64plus/get/0.3.tar.bz2";
    sha256 = "1mnxi4k011dd300k35li2p6x4wccwi6im21qz8dkznnz397ps67c";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs = [ python wxGTK29 SDL libX11 libGLU_combined ];

  preConfigure = ''
    tar xf ${mupen64plus.src}
    APIDIR=$(eval echo `pwd`/mupen64plus*/source/mupen64plus-core/src/api)
    export CXXFLAGS="-I${libX11.dev}/include/X11 -DLIBDIR=\\\"${mupen64plus}/lib/\\\""
    export LDFLAGS="-lwx_gtk2u_adv-2.9"

    wafConfigureFlagsArray+=("--mupenapi=$APIDIR" "--wxconfig=`type -P wx-config`")
  '';

  NIX_CFLAGS_COMPILE = "-fpermissive";

  meta = {
    description = "GUI for the Mupen64Plus 2.0 emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = https://bitbucket.org/auria/wxmupen64plus/wiki/Home;
  };
}
