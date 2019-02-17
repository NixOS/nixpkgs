{ stdenv, fetchFromRepoOrCz, fetchpatch, nasm, perl, python, libuuid, mtools, makeWrapper }:

stdenv.mkDerivation rec {
  # This is syslinux-6.04-pre3^1; syslinux-6.04-pre3 fails to run.
  # Same issue here https://www.syslinux.org/archives/2019-February/026330.html
  name = "syslinux-2019-02-07";

  src = fetchFromRepoOrCz {
    repo = "syslinux";
    rev = "b40487005223a78c3bb4c300ef6c436b3f6ec1f7";
    sha256 = "1qrxl1114sr2i2791z9rf8v53g200aq30f08808d7i8qnmgvxl2w";
  };

  postPatch = ''
    substituteInPlace Makefile --replace /bin/pwd $(type -P pwd)
    substituteInPlace utils/ppmtolss16 --replace /usr/bin/perl $(type -P perl)

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
    maintainers = [ maintainers.samueldr ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
