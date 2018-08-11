{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "p7zip-${version}";
  version = "16.02";

  src = fetchurl {
    url = "mirror://sourceforge/p7zip/p7zip_${version}_src_all.tar.bz2";
    sha256 = "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f";
  };

  patches = [
    (fetchpatch rec {
      name = "CVE-2016-9296.patch";
      url = "https://salsa.debian.org/debian/p7zip/raw/debian/${version}+dfsg-6/debian/patches/12-${name}";
      sha256 = "09wbkzai46bwm8zmplsz0m4jck3qn7snr68i9p1gsih300zidj0m";
    })
    (fetchpatch rec {
      name = "CVE-2017-17969.patch";
      url = "https://salsa.debian.org/debian/p7zip/raw/debian/${version}+dfsg-6/debian/patches/13-${name}";
      sha256 = "00pycdwx6gw7w591bg54ym6zhbxgn47p3zhms6mnmaycfzw09mkn";
    })
  ];

  # Default makefile is full of impurities on Darwin. The patch doesn't hurt Linux so I'm leaving it unconditional
  postPatch = ''
    sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits

    # I think this is a typo and should be CXX? Either way let's kill it
    sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
  '';

  preConfigure = ''
    makeFlagsArray=(DEST_HOME=$out)
    buildFlags=all3
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_llvm_64bits makefile.machine
  '';

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://p7zip.sourceforge.net/;
    description = "A port of the 7-zip archiver";
    # license = stdenv.lib.licenses.lgpl21Plus; + "unRAR restriction"
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
