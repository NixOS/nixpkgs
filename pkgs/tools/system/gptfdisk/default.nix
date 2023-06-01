{ fetchurl, lib, stdenv, libuuid, popt, icu, ncurses, nixosTests }:

stdenv.mkDerivation rec {
  pname = "gptfdisk";
  version = "1.0.9";

  src = fetchurl {
    # https://www.rodsbooks.com/gdisk/${name}.tar.gz also works, but the home
    # page clearly implies a preference for using SourceForge's bandwidth:
    url = "mirror://sourceforge/gptfdisk/${pname}-${version}.tar.gz";
    sha256 = "sha256-2v6tJpP6646Ll4MrI0B/btWzIZvBeE9ILdhVd04tUMI=";
  };

  patches = [
    # issues with popt 1.19 (from upstream but not yet released):
    # https://github.com/rpm-software-management/popt/issues/80
    ./popt-1-19.patch

    # fix UUID generation (from upstream but not yet released):
    # https://sourceforge.net/p/gptfdisk/code/ci/6a8416cbd12d55f882bb751993b94f72d338d96f/
    # https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1853985.html
    ./uuid.patch
  ];

  postPatch = ''
    patchShebangs gdisk_test.sh
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.mac --replace \
      "-mmacosx-version-min=10.4" "-mmacosx-version-min=10.6"
    substituteInPlace Makefile.mac --replace \
      " -arch i386" ""
    substituteInPlace Makefile.mac --replace \
      "-arch x86_64" ""
    substituteInPlace Makefile.mac --replace \
      "-arch arm64" ""
    substituteInPlace Makefile.mac --replace \
      " -I/opt/local/include -I /usr/local/include -I/opt/local/include" ""
    substituteInPlace Makefile.mac --replace \
      "/usr/local/Cellar/ncurses/6.2/lib/libncurses.dylib" "${ncurses.out}/lib/libncurses.dylib"
  '';

  buildPhase = lib.optionalString stdenv.isDarwin "make -f Makefile.mac";
  buildInputs = [ libuuid popt icu ncurses ];

  installPhase = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    for prog in gdisk sgdisk fixparts cgdisk
    do
        install -v -m755 $prog $out/sbin
        install -v -m644 $prog.8 $out/share/man/man8
    done
  '';

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isx86 {
    installer-simpleLabels = nixosTests.installer.simpleLabels;
  };

  meta = with lib; {
    description = "Set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";
    license = licenses.gpl2;
    homepage = "https://www.rodsbooks.com/gdisk/";
    platforms = platforms.all;
    maintainers = [ maintainers.ehmry ];
  };
}
