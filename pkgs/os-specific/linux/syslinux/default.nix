{ stdenv, fetchFromRepoOrCz, fetchurl, nasm, perl, python3, libuuid, mtools, makeWrapper }:

stdenv.mkDerivation {
  name = "syslinux-2019-02-07";

  # This is syslinux-6.04-pre3^1; syslinux-6.04-pre3 fails to run.
  # Same issue here https://www.syslinux.org/archives/2019-February/026330.html
  src = fetchFromRepoOrCz {
    repo = "syslinux";
    rev = "b40487005223a78c3bb4c300ef6c436b3f6ec1f7";
    sha256 = "1qrxl1114sr2i2791z9rf8v53g200aq30f08808d7i8qnmgvxl2w";
  };

  patches = let
    mkURL = commit: patchName:
      "https://salsa.debian.org/images-team/syslinux/raw/${commit}/debian/patches/"
      + patchName;
  in [
    (fetchurl {
      url = mkURL "fa1349f1" "0002-gfxboot-menu-label.patch";
      sha256 = "06ifgzbpjj4picpj17zgprsfi501zf4pp85qjjgn29i5rs291zni";
    })
    (fetchurl {
      url = mkURL "477e56d2" "0005-gnu-efi-version-compatibility.patch";
      sha256 = "041568b4abb79wynyps1n04lg4fr26rc3sbjncz99pp0mbz0ajlm";
    })
    (fetchurl {
      # mbr.bin: too big (452 > 440)
      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=906414
      url = mkURL "7468ef0e38c43" "0016-strip-gnu-property.patch";
      sha256 = "17n63b8wz6szv8npla1234g1ip7lqgzx2whrpv358ppf67lq8vwm";
    })
    (fetchurl {
      # mbr.bin: too big (452 > 440)
      url = mkURL "012e1dd312eb" "0017-single-load-segment.patch";
      sha256 = "0azqzicsjw47b9ppyikhzaqmjl4lrvkxris1356bkmgcaiv6d98b";
    })
    (fetchurl {
      url = mkURL "26f0e7b2" "0018-prevent-pow-optimization.patch";
      sha256 = "1c8g0jz5yj9a0rsmryx9vdjsw4hw8mjfcg05c9pmyjg85w3dfp3m";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /bin/pwd $(type -P pwd)
    substituteInPlace utils/ppmtolss16 --replace /usr/bin/perl $(type -P perl)

    # fix tests
    substituteInPlace tests/unittest/include/unittest/unittest.h \
      --replace /usr/include/ ""
  '';

  nativeBuildInputs = [ nasm perl python3 ];
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
