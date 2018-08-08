{ stdenv, fetchFromGitHub, fetchurl, nasm, perl, python, libuuid, mtools, makeWrapper }:

stdenv.mkDerivation rec {
  name = "syslinux-2015-11-09";

  src = fetchFromGitHub {
    owner = "geneC";
    repo = "syslinux";
    rev = "0cc9a99e560a2f52bcf052fd85b1efae35ee812f";
    sha256 = "0wk3r5ki4lc334f9jpml07wpl8d0bnxi9h1l4h4fyf9a0d7n4kmw";
  };

  patches = [
    ./perl-deps.patch
    (fetchurl {
      # ldlinux.elf: Not enough room for program headers, try linking with -N
      name = "not-enough-room.patch";
      url = "https://anonscm.debian.org/cgit/collab-maint/syslinux.git/plain/"
          + "debian/patches/0014_fix_ftbfs_no_dynamic_linker.patch?id=a556ad7";
      sha256 = "0ijqjsjmnphmvsx0z6ppnajsfv6xh6crshy44i2a5klxw4nlvrsw";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /bin/pwd $(type -P pwd)
    substituteInPlace gpxe/src/Makefile.housekeeping --replace /bin/echo $(type -P echo)
    substituteInPlace utils/ppmtolss16 --replace /usr/bin/perl $(type -P perl)
    substituteInPlace gpxe/src/Makefile --replace /usr/bin/perl $(type -P perl)

    # fix tests
    substituteInPlace tests/unittest/include/unittest/unittest.h \
      --replace /usr/include/ ""
  '';

  nativeBuildInputs = [ nasm perl python ];
  buildInputs = [ libuuid makeWrapper ];

  enableParallelBuilding = false; # Fails very rarely with 'No rule to make target: ...'
  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  stripDebugList = "bin sbin share/syslinux/com32";

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/sbin"
    "LIBDIR=$(out)/lib"
    "INCDIR=$(out)/include"
    "DATADIR=$(out)/share"
    "MANDIR=$(out)/share/man"
    "PERL=perl"
    "bios"
  ];

  doCheck = false; # fails. some fail in a sandbox, others require qemu

  postInstall = ''
    wrapProgram $out/bin/syslinux \
      --prefix PATH : "${mtools}/bin"

    # Delete com32 headers to save space, nobody seems to be using them
    rm -rf $out/share/syslinux/com32
  '';

  meta = with stdenv.lib; {
    homepage = http://www.syslinux.org/;
    description = "A lightweight bootloader";
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
