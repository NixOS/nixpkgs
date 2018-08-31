{ stdenv, lib, fetchurl
, linuxHeaders ? null
, useBSDCompatHeaders ? true
}:
let
  cdefs_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-cdefs.h";
    sha256 = "16l3dqnfq0f20rzbkhc38v74nqcsh9n3f343bpczqq8b1rz6vfrh";
  };
  queue_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-queue.h";
    sha256 = "12qm82id7zys92a1qh2l1qf2wqgq6jr4qlbjmqyfffz3s3nhfd61";
  };
  tree_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-tree.h";
    sha256 = "14igk6k00bnpfw660qhswagyhvr0gfqg4q55dxvaaq7ikfkrir71";
  };

  # iconv tool, implemented by musl author.
  # Original: http://git.etalabs.net/cgit/noxcuse/plain/src/iconv.c?id=02d288d89683e99fd18fe9f54d4e731a6c474a4f
  # We use copy from Alpine which fixes error messages, see:
  # https://git.alpinelinux.org/cgit/aports/commit/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f
  iconv_c = fetchurl {
    name = "iconv.c";
    url = "https://git.alpinelinux.org/cgit/aports/plain/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f";
    sha256 = "1mzxnc2ncq8lw9x6n7p00fvfklc9p3wfv28m68j0dfz5l8q2k6pp";
  };

in
stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.19";

  src = fetchurl {
    url    = "https://www.musl-libc.org/releases/musl-${version}.tar.gz";
    sha256 = "1nf1wh44bhm8gdcfr75ayib29b99vpq62zmjymrq7f96h9bshnfv";
  };

  enableParallelBuilding = true;

  # Disable auto-adding stack protector flags,
  # so musl can selectively disable as needed
  hardeningDisable = [ "stackprotector" ];

  # Leave these, be friendlier to debuggers/perf tools
  # Don't force them on, but don't force off either
  postPatch = ''
    substituteInPlace configure \
      --replace -fno-unwind-tables "" \
      --replace -fno-asynchronous-unwind-tables ""
  '';

  patches = [
    # Minor touchup to build system making dynamic linker symlink relative
    (fetchurl {
      url = https://raw.githubusercontent.com/openwrt/openwrt/87606e25afac6776d1bbc67ed284434ec5a832b4/toolchain/musl/patches/300-relative.patch;
      sha256 = "0hfadrycb60sm6hb6by4ycgaqc9sgrhh42k39v8xpmcvdzxrsq2n";
    })
  ];
  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  CFLAGS="-fstack-protector-strong" + lib.optionalString stdenv.hostPlatform.isPower " -mlong-double-64";

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "--enable-debug"
    "--enable-wrapper=all"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;
  separateDebugInfo = true;

  NIX_DONT_SET_RPATH = true;

  postInstall = ''
    # Not sure why, but link in all but scsi directory as that's what uclibc/glibc do.
    # Apparently glibc provides scsi itself?
    (cd $dev/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)

    # Strip debug out of the static library
    $STRIP -S $out/lib/libc.a
    mkdir -p $out/bin

    # Create 'ldd' symlink, builtin
    ln -rs $out/lib/libc.so $out/bin/ldd

    # (impure) cc wrapper around musl for interactive usuage
    for i in musl-gcc musl-clang ld.musl-clang; do
      moveToOutput bin/$i $dev
    done
    moveToOutput lib/musl-gcc.specs $dev
    substituteInPlace $dev/bin/musl-gcc \
      --replace $out/lib/musl-gcc.specs $dev/lib/musl-gcc.specs

    # provide 'iconv' utility, using just-built headers, libc/ldso
    $CC ${iconv_c} -o $out/bin/iconv \
      -I$dev/include \
      -L$out/lib -Wl,-rpath=$out/lib \
      -lc \
      -B $out/lib \
      -Wl,-dynamic-linker=$(ls $out/lib/ld-*)
  '' + lib.optionalString useBSDCompatHeaders ''
    install -D ${queue_h} $dev/include/sys/queue.h
    install -D ${cdefs_h} $dev/include/sys/cdefs.h
    install -D ${tree_h} $dev/include/sys/tree.h
  '';

  passthru.linuxHeaders = linuxHeaders;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
