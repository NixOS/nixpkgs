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

  stack_chk_fail_local_c = fetchurl {
    url = "https://git.alpinelinux.org/aports/plain/main/musl/__stack_chk_fail_local.c?h=3.10-stable";
    sha256 = "1nhkzzy9pklgjcq2yg89d3l18jif331srd3z3vhy5qwxl1spv6i9";
  };

  # iconv tool, implemented by musl author.
  # Original: http://git.etalabs.net/cgit/noxcuse/plain/src/iconv.c?id=02d288d89683e99fd18fe9f54d4e731a6c474a4f
  # We use copy from Alpine which fixes error messages, see:
  # https://git.alpinelinux.org/aports/commit/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f
  iconv_c = fetchurl {
    name = "iconv.c";
    url = "https://git.alpinelinux.org/aports/plain/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f";
    sha256 = "1mzxnc2ncq8lw9x6n7p00fvfklc9p3wfv28m68j0dfz5l8q2k6pp";
  };

  arch = if stdenv.hostPlatform.isx86_64
    then "x86_64"
    else if stdenv.hostPlatform.isx86_32
      then "i386"
      else null;

in
stdenv.mkDerivation rec {
  pname = "musl";
  version = "1.2.3";

  src = fetchurl {
    url    = "https://musl.libc.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-fVsLYGJSHkYn4JnkydyCSNMqMChelZt+7Kp4DPjP1KQ=";
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
      url = "https://raw.githubusercontent.com/openwrt/openwrt/87606e25afac6776d1bbc67ed284434ec5a832b4/toolchain/musl/patches/300-relative.patch";
      sha256 = "0hfadrycb60sm6hb6by4ycgaqc9sgrhh42k39v8xpmcvdzxrsq2n";
    })
  ];
  CFLAGS = [ "-fstack-protector-strong" ]
    ++ lib.optional stdenv.hostPlatform.isPower "-mlong-double-64";

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "--enable-debug"
    "--enable-wrapper=all"
    "--syslibdir=${placeholder "out"}/lib"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  separateDebugInfo = true;

  NIX_DONT_SET_RPATH = true;

  preBuild = ''
    ${if (stdenv.targetPlatform.libc == "musl" && stdenv.targetPlatform.isx86_32) then
    "# the -x c flag is required since the file extension confuses gcc
    # that detect the file as a linker script.
    $CC -x c -c ${stack_chk_fail_local_c} -o __stack_chk_fail_local.o
    $AR r libssp_nonshared.a __stack_chk_fail_local.o"
      else ""
    }
  '';

  postInstall = ''
    # Not sure why, but link in all but scsi directory as that's what uclibc/glibc do.
    # Apparently glibc provides scsi itself?
    (cd $dev/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)

    # Strip debug out of the static library
    $STRIP -S $out/lib/libc.a
    mkdir -p $out/bin


    ${if (stdenv.targetPlatform.libc == "musl" && stdenv.targetPlatform.isx86_32) then
      "install -D libssp_nonshared.a $out/lib/libssp_nonshared.a
      $STRIP -S $out/lib/libssp_nonshared.a"
      else ""
    }

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
  '' + lib.optionalString (arch != null) ''
    # Create 'libc.musl-$arch' symlink
    ln -rs $out/lib/libc.so $out/lib/libc.musl-${arch}.so.1
  '' + lib.optionalString useBSDCompatHeaders ''
    install -D ${queue_h} $dev/include/sys/queue.h
    install -D ${cdefs_h} $dev/include/sys/cdefs.h
    install -D ${tree_h} $dev/include/sys/tree.h
  '';

  passthru.linuxHeaders = linuxHeaders;

  meta = with lib; {
    description = "An efficient, small, quality libc implementation";
    homepage    = "https://musl.libc.org/";
    changelog   = "https://git.musl-libc.org/cgit/musl/tree/WHATSNEW?h=v${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice dtzWill ];
  };
}
