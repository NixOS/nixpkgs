{ lib
, stdenv
, fetchgit
, fetchurl
, libuuid
, makeWrapper
, mtools
, nasm
, perl
, python3
}:

stdenv.mkDerivation {
  pname = "syslinux";
  version = "unstable-2019-02-07";

  # This is syslinux-6.04-pre3^1; syslinux-6.04-pre3 fails to run.
  # Same issue here https://www.syslinux.org/archives/2019-February/026330.html
  src = fetchgit {
    url = "https://repo.or.cz/syslinux";
    rev = "b40487005223a78c3bb4c300ef6c436b3f6ec1f7";
    sha256 = "sha256-GqvRTr9mA2yRD0G0CF11x1X0jCgqV4Mh+tvE0/0yjqk=";
    fetchSubmodules = true;
  };

  patches = let
    fetchDebianPatch = name: commit: hash:
      fetchurl {
        url = "https://salsa.debian.org/images-team/syslinux/raw/"
              + commit + "/debian/patches/" + name;
        inherit name hash;
      };
    fetchArchlinuxPatch = name: commit: hash:
      fetchurl {
        url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/"
              + commit + "/trunk/" + name;
        inherit name hash;
      };
  in [
    ./gcc10.patch
    (fetchDebianPatch
      "0002-gfxboot-menu-label.patch"
      "fa1349f1"
      "sha256-0f6QhM4lJmGflLige4n7AZTodL7vnyAvi5dIedd/Lho=")
    (fetchArchlinuxPatch
      "0005-gnu-efi-version-compatibility.patch"
      "821c3da473d1399d930d5b4a086e46a4179eaa45"
      "sha256-hhCVnfbAFWj/R4yh60qsMB87ofW9RznarsByhl6L4tc=")
    (fetchArchlinuxPatch
      "0025-reproducible-build.patch"
      "821c3da473d1399d930d5b4a086e46a4179eaa45"
      "sha256-mnb291pCSFvDNxY7o4BosJ94ib3BpOGRQIiY8Q3jZmI=")
    (fetchDebianPatch
      # mbr.bin: too big (452 > 440)
      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=906414
      "0016-strip-gnu-property.patch"
      "7468ef0e38c43"
      "sha256-lW+E6THuXlTGvhly0f/D9NwYHhkiKHot2l+bz9Eaxp4=")
    (fetchDebianPatch
      # mbr.bin: too big (452 > 440)
      "0017-single-load-segment.patch"
      "012e1dd312eb"
      "sha256-C6VmdlTs1blMGUHH3OfOlFBZsfpwRn9vWodwqVn8+Cs=")
    (fetchDebianPatch
      "0018-prevent-pow-optimization.patch"
      "26f0e7b2"
      "sha256-dVzXBi/oSV9vYgU85mRFHBKuZdup+1x1BipJX74ED7E=")
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail /bin/pwd $(type -P pwd)
    substituteInPlace utils/ppmtolss16 --replace-fail /usr/bin/perl $(type -P perl)

    # fix tests
    substituteInPlace tests/unittest/include/unittest/unittest.h \
      --replace-fail /usr/include/ ""

    # Hack to get `gcc -m32' to work without having 32-bit Glibc headers.
    mkdir gnu-efi/inc/ia32/gnu
    touch gnu-efi/inc/ia32/gnu/stubs-32.h
  '';

  nativeBuildInputs = [
    nasm
    perl
    python3
    makeWrapper
  ];

  buildInputs = [
    libuuid
  ];

  # Fails very rarely with 'No rule to make target: ...'
  enableParallelBuilding = false;

  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  stripDebugList = [ "bin" "sbin" "share/syslinux/com32" ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: acpi/xsdt.o:/build/syslinux-b404870/com32/gpllib/../gplinclude/memory.h:40: multiple definition of
  #     `e820_types'; memory.o:/build/syslinux-b404870/com32/gpllib/../gplinclude/memory.h:40: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/sbin"
    "DATADIR=$(out)/share"
    "MANDIR=$(out)/share/man"
    "PERL=perl"
    "HEXDATE=0x00000000"
  ]
  ++ lib.optionals stdenv.hostPlatform.isi686 [ "bios" "efi32" ];

  # Some tests require qemu, some others fail in a sandboxed environment
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/syslinux \
      --prefix PATH : "${mtools}/bin"

    # Delete com32 headers to save space, nobody seems to be using them
    rm -rf $out/share/syslinux/com32
  '';

  meta = with lib; {
    homepage = "https://www.syslinux.org/";
    description = "A lightweight bootloader";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.samueldr ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
