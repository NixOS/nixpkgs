{ stdenv, fetchurl, xlibsWrapper, zlib, libjpeg, imake, gccmakedep, libXmu
, libXaw, libXpm, libXp , perl, xauth, fontDirectories, openssh }:

stdenv.mkDerivation {
  name = "tightvnc-1.3.10";

  src = fetchurl {
    url = mirror://sourceforge/vnc-tight/tightvnc-1.3.10_unixsrc.tar.bz2;
    sha256 = "f48c70fea08d03744ae18df6b1499976362f16934eda3275cead87baad585c0d";
  };

  patches = [
    ./1.3.10-CVE-2019-15678.patch
    ./1.3.10-CVE-2019-15679.patch
    ./1.3.10-CVE-2019-15680.patch
    ./1.3.10-CVE-2019-8287.patch
  ];

  # for the builder script
  inherit fontDirectories;

  hardeningDisable = [ "format" ];

  buildInputs = [ xlibsWrapper zlib libjpeg imake gccmakedep libXmu libXaw
                  libXpm libXp xauth openssh ];

  postPatch = ''
    fontPath=
    for i in $fontDirectories; do
      for j in $(find $i -name fonts.dir); do
        addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
      done
    done

    sed -i "s@/usr/bin/ssh@${openssh}/bin/ssh@g" vncviewer/vncviewer.h

    sed -e 's@/usr/bin/perl@${perl}/bin/perl@' \
        -e 's@unix/:7100@'$fontPath'@' \
        -i vncserver

    sed -e 's@.* CppCmd .*@#define CppCmd		cpp@' -i Xvnc/config/cf/linux.cf
    sed -e 's@.* CppCmd .*@#define CppCmd		cpp@' -i Xvnc/config/cf/Imake.tmpl
    sed -i \
        -e 's@"uname","xauth","Xvnc","vncpasswd"@"uname","Xvnc","vncpasswd"@g' \
        -e "s@\<xauth\>@${xauth}/bin/xauth@g" \
        vncserver
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  installPhase = ''
    runHook preInstall

    ./vncinstall $out/bin $out/share/man

    runHook postInstall
  '';

  postInstall = ''
    # fix HTTP client:
    mkdir -p $out/share/tightvnc
    cp -r classes $out/share/tightvnc
    substituteInPlace $out/bin/vncserver \
      --replace /usr/local/vnc/classes $out/share/tightvnc/classes
  '';

  meta = {
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://vnc-tight.sourceforge.net/;
    description = "Improved version of VNC";

    longDescription = ''
      TightVNC is an improved version of VNC, the great free
      remote-desktop tool. The improvements include bandwidth-friendly
      "tight" encoding, file transfers in the Windows version, enhanced
      GUI, many bugfixes, and more.
    '';

    maintainers = [];
    platforms = stdenv.lib.platforms.unix;
  };
}
