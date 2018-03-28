{ stdenv, lib, fetchurl
, buildPackages
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

in
stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.19";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/musl-${version}.tar.gz";
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

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "--enable-debug"
    "CFLAGS=-fstack-protector-strong"
    # Fix cycle between outputs
    "--disable-wrapper"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;
  separateDebugInfo = true;

  postInstall =
  ''
    # Not sure why, but link in all but scsi directory as that's what uclibc/glibc do.
    # Apparently glibc provides scsi itself?
    (cd $dev/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
  '' + ''
    # Strip debug out of the static library
    $STRIP -S $out/lib/libc.a
  '' + ''
    mkdir -p $out/bin
    # Create 'ldd' symlink, builtin
    ln -s $out/lib/libc.so $out/bin/ldd
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
