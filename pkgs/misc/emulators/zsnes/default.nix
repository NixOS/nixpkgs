{stdenv, fetchurl, fetchpatch, nasm, SDL, zlib, libpng, ncurses, mesa}:

stdenv.mkDerivation {
  name = "zsnes-1.51";

  src = fetchurl {
    url = mirror://sourceforge/zsnes/zsnes151src.tar.bz2;
    sha256 = "08s64qsxziv538vmfv38fg1rfrz5k95dss5zdkbfxsbjlbdxwmi8";
  };

  patches = [ (fetchpatch {
                url = "https://raw.githubusercontent.com/emillon/zsnes/fc160b2538738995f600f8405d23a66b070dac02/debian/patches/0003-gcc-4.3-ftbfs.patch";
                sha256 = "1rlqjxnx21iz03414bamqrpysaxbvmfacfnk111233yxjd4vhq89";
              })
              (fetchpatch {
                url = "https://raw.githubusercontent.com/emillon/zsnes/fc160b2538738995f600f8405d23a66b070dac02/debian/patches/0009-hat-events.patch";
                sha256 = "1az5vxjff22hqlsv0nmliax3ziwcr9kc75na805v9f66s8fmj5rf";
              })
              (fetchpatch {
                url = "https://raw.githubusercontent.com/emillon/zsnes/fc160b2538738995f600f8405d23a66b070dac02/debian/patches/0010-Fix-build-with-libpng-1.5.patch";
                sha256 = "1vjfraxjw6f496j3w8r581m3lbn16s0nx3hskzj14hl9ycfskhnr";
              })
              (fetchpatch {
                url = "https://raw.githubusercontent.com/emillon/zsnes/fc160b2538738995f600f8405d23a66b070dac02/debian/patches/0012-Fix-build-with-gcc-4.7.patch";
                sha256 = "1d8m0vxi8wf9z4wfjx2cc48p1wy2qadgvcm88dg1jncg334jwfrg";
              })
              (fetchpatch {
                url = "https://raw.githubusercontent.com/emillon/zsnes/fc160b2538738995f600f8405d23a66b070dac02/debian/patches/zsnes-linux-resume-freeze-fix.patch";
                sha256 = "0gvf6gsqxxfah1s80ya2l5yils2kv9xa6faajdyby7xipzkc6qc7";
              })
            ];

  buildInputs = [ nasm SDL zlib libpng ncurses mesa ];

  preConfigure = ''
    cd src
    sed -i "/^STRIP/d" configure
  '';

  configureFlags = [ "--enable-release" ];

  meta = {
    description = "A Super Nintendo Entertainment System Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    homepage = http://www.zsnes.com;
  };
}
