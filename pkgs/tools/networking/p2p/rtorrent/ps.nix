{ stdenv, rtorrent, openssl, openssl_1_1, libtorrent, libtorrent-ps, fetchFromGitHub }:
let
  ps = fetchFromGitHub {
    rev = "37c9d4b45be2ab5f0b7ff9123c471fd517c22033";
    owner = "pyroscope";
    repo = "rtorrent-ps";
    sha256 = "1hl7mwndra30q3bcjprzqh2j9dirx6ym8mzamgydp1iywk0dqdwj";
  };
  rtorrent_0_9_6 = rtorrent.overrideAttrs (o: rec {
    name = "rtorrent-${version}";
    version = "0.9.6";
    src = fetchFromGitHub {
      owner = "rakshasa";
      repo = "rtorrent";
      rev = "${version}";
      sha256 = "0iyxmjr1984vs7hrnxkfwgrgckacqml0kv4bhj185w9bhjqvgfnf";
    };
  });
in

rtorrent_0_9_6.overrideAttrs (o: rec {
  version = "1.1-${builtins.substring 0 7 ps.rev}";
  name = "rtorrent-ps-${version}";
  buildInputs = (stdenv.lib.subtractLists [ libtorrent openssl ] o.buildInputs) ++ [ libtorrent-ps openssl_1_1 ];
  
  patches = (o.patches or []) ++ (map (x: "${ps}/patches/${x}") [
    "backport*_${o.version}_*.patch"
    "rt-base-cppunit-pkgconfig.patch"
    "ps-*_all.patch"
    "ps-*_${o.version}.patch"
    "pyroscope.patch"
    "ui_pyroscope.patch"
  ]);
  
  postPatch = ''
    ln -s ${ps}/patches/*.{cc,h} src/
    RT_HEX_VERSION=$(printf "0x%02X%02X%02X" ${stdenv.lib.replaceChars ["."] [" "] o.version})
    sed -i -e "s:\\(AC_DEFINE(HAVE_CONFIG_H.*\\):\1  AC_DEFINE(RT_HEX_VERSION, "$RT_HEX_VERSION", for CPP if checks):" configure.ac
    grep "AC_DEFINE.*API_VERSION" configure.ac >/dev/null || sed -i -e "s:\\(AC_DEFINE(HAVE_CONFIG_H.*\\):\1  AC_DEFINE(API_VERSION, 0, api version):" configure.ac
    sed -i -e 's/rTorrent \" VERSION/rTorrent PS-'"${version}"' " VERSION/' src/ui/download_list.cc
  '';
  
  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    homepage = https://github.com/pyroscope/rtorrent-ps;
    description = "Extended rTorrent distribution with UI enhancements, colorization, and some added features";

    platforms = platforms.unix;
    maintainers = with maintainers; [ yorickvp ];
    license = licenses.gpl2Plus;
  };
})
