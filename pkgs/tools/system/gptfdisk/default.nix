{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

stdenv.mkDerivation rec {
  pname = "gptfdisk";
  version = "1.0.5";

  src = fetchurl {
    # https://www.rodsbooks.com/gdisk/${name}.tar.gz also works, but the home
    # page clearly implies a preference for using SourceForge's bandwidth:
    url = "mirror://sourceforge/gptfdisk/${pname}-${version}.tar.gz";
    sha256 = "0bybgp30pqxb6x5krxazkq4drca0gz4inxj89fpyr204rn3kjz8f";
  };

  postPatch = ''
    patchShebangs gdisk_test.sh
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.mac --replace \
      "-mmacosx-version-min=10.4" "-mmacosx-version-min=10.6"
    substituteInPlace Makefile.mac --replace \
      " -arch i386" ""
    substituteInPlace Makefile.mac --replace \
      " -I/opt/local/include -I /usr/local/include -I/opt/local/include" ""
    substituteInPlace Makefile.mac --replace \
      "/opt/local/lib/libncurses.a" "${ncurses.out}/lib/libncurses.dylib"
  '';

  buildPhase = stdenv.lib.optionalString stdenv.isDarwin "make -f Makefile.mac";
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

  meta = with stdenv.lib; {
    description = "Set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";
    license = licenses.gpl2;
    homepage = https://www.rodsbooks.com/gdisk/;
    platforms = platforms.all;
  };
}
