{ stdenv,
  fetchurl,
  autoconf,
  automake,
  alsaLib,
  pkgconfig,
  gtk2,
  gtk3,
  fltk13,
  qt3,
  perl,
  python,
  pygobject,
  pygtk,
  pyalsa,
  makeWrapper,
  libtool,
  alsa-firmware
}:

stdenv.mkDerivation rec {
  name = "alsa-tools-1.0.29";

  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.0.29.tar.bz2";
    sha256 = "94abf0ab5a73f0710c70d4fb3dc1003af5bae2d2ed721d59d245b41ad0f2fbd1";
  };

  buildInputs = [
    autoconf automake alsaLib pkgconfig gtk2 gtk3 fltk13 qt3 perl python
    pygobject pygtk pyalsa makeWrapper libtool
  ];

  GITCOMPILE_ARGS="--prefix= ";
  GITCOMPILE_NO_MAKE=1;

  automakeVersion = (builtins.parseDrvName automake.name).version;
  automakeMajorVersion = stdenv.lib.concatStringsSep "."
    (stdenv.lib.take 2 (stdenv.lib.splitString "." automakeVersion));
  AUTOMAKE_DIR="${automake}/share/automake-${automakeMajorVersion}";

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" "fixupPhase" ];

  patchPhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DDATAPATH=\"${alsa-firmware}/lib/firmware\"";
    patch -p0 < ${./ld10k1_libtool.patch}
    patch -p0 < ${./qlo10k1_find_macro.patch}
    patch -p0 < ${./hdajacksensetest_gitcompile.patch}
    chmod u+x hdajacksensetest/gitcompile
    patchShebangs .

    # prevent seq/sbiload/gitcompile from being evaluated more than once
    pushd seq
    rm gitcompile; touch gitcompile; chmod u+x gitcompile;
    popd

    sed -i 's,"$CONFIGURE_ARGS","$(CONFIGURE_ARGS)",' Makefile
  '';

  installPhase = "make DESTDIR=$out install";

  fixupPhase = ''
    sed -i "s,/bin/lo10k1,$out/bin/lo10k1,g" $out/bin/init_{audigy,audigy_eq10,live}
    sed -i "s,bindir=/bin,bindir=$out/bin," $out/bin/init_live
    wrapProgram $out/bin/hwmixvolume --prefix PYTHONPATH : $PYTHONPATH
    mv $out/sbin/* $out/bin
    patchShebangs $out
  '';

  meta = {
    homepage = http://www.alsa-project.org/;
    description = "ALSA Tools contains advanced tools for certain sound cards";
    platforms = stdenv.lib.platforms.linux;
    license = with stdenv.lib.licenses; [ gpl2Plus gpl2 free ];
  };
}
