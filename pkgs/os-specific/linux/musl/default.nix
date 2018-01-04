{ stdenv, fetchurl, linuxHeaders, useBSDCompatHeaders ? true }:

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
  version = "1.1.18";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "0651lnj5spckqjf83nz116s8qhhydgqdy3rkl4icbh5f05fyw5yh";
  };

  enableParallelBuilding = true;

  # Disable auto-adding stack protector flags,
  # so musl can selectively disable as needed
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "CFLAGS=-fstack-protector-strong"
    # Fix cycle between outputs
    "--disable-wrapper"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;
  dontStrip = true;

  postInstall =
  ''
    # Not sure why, but link in all but scsi directory as that's what uclibc/glibc do.
    # Apparently glibc provides scsi itself?
    (cd $dev/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
  '' +
  ''
    mkdir -p $out/bin
    # Create 'ldd' symlink, builtin
    ln -s $out/lib/libc.so $out/bin/ldd
  '' + stdenv.lib.optionalString useBSDCompatHeaders ''
    install -D ${queue_h} $dev/include/sys/queue.h
    install -D ${cdefs_h} $dev/include/sys/cdefs.h
    install -D ${tree_h} $dev/include/sys/tree.h
  '';

  passthru.linuxHeaders = linuxHeaders;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
