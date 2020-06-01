{ stdenv, fetchurl, fetchpatch, lib, enableUnfree ? false }:

stdenv.mkDerivation rec {
  pname = "p7zip";
  version = "16.02";

  src = fetchurl {
    url = "mirror://sourceforge/p7zip/p7zip_${version}_src_all.tar.bz2";
    sha256 = "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f";
  };

  patches = [
    ./12-CVE-2016-9296.patch
    ./13-CVE-2017-17969.patch
    (fetchpatch {
      name = "3-CVE-2018-5996.patch";
      url = "https://raw.githubusercontent.com/termux/termux-packages/master/packages/p7zip/3-CVE-2018-5996.patch";
      sha256 = "1zivvkazmza0653i498ccp3zbpbpc7dvxl3zxwllbx41b6n589yp";
    })
    (fetchpatch {
      name = "4-CVE-2018-10115.patch";
      url = "https://raw.githubusercontent.com/termux/termux-packages/master/packages/p7zip/4-CVE-2018-10115.patch";
      sha256 = "1cr7q8gnrk9yp6dcvxaqi1yhdbgp964nkv65ls41mw1kdfm44zn6";
    })
  ];

  # Default makefile is full of impurities on Darwin. The patch doesn't hurt Linux so I'm leaving it unconditional
  postPatch = ''
    sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits

    # I think this is a typo and should be CXX? Either way let's kill it
    sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
  '' + stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace makefile.machine \
      --replace 'CC=gcc'  'CC=${stdenv.cc.targetPrefix}gcc' \
      --replace 'CXX=g++' 'CXX=${stdenv.cc.targetPrefix}g++'
  '' + lib.optionalString (!enableUnfree) ''
    # Remove non-free RAR source code
    # (see DOC/License.txt, https://fedoraproject.org/wiki/Licensing:Unrar)
    rm -r CPP/7zip/Compress/Rar*
    find . -name makefile'*' -exec sed -i '/Rar/d' {} +
  '';

  preConfigure = ''
    makeFlagsArray=(DEST_HOME=$out)
    buildFlags=all3
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_llvm_64bits makefile.machine
  '';

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  meta = {
    homepage = "http://p7zip.sourceforge.net/";
    description = "A port of the 7-zip archiver";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    knownVulnerabilities = [
      # p7zip is abandoned, according to this thread on its forums:
      # https://sourceforge.net/p/p7zip/discussion/383043/thread/fa143cf2/#1817
      "p7zip is abandoned and may not receive important security fixes"
    ];
    # RAR code is under non-free UnRAR license, but we remove it
    license = if enableUnfree then lib.licenses.unfree else lib.licenses.lgpl2Plus;
  };
}
