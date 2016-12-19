{ stdenv, fetchgit, pkgconfig, libuuid, openssl }:

stdenv.mkDerivation rec {
  version = "20130507";
  checkout = "25/50225/2";

  name = "vboot_reference-${version}";

  src = fetchgit {
    url = https://chromium.googlesource.com/chromiumos/platform/vboot_reference;
    rev = "refs/changes/${checkout}";
    sha256 = "14d3a93ha5k4al4ib43nyn1ppx7kgb12xw6mkflhx8nxmx8827nc";
  };

  buildInputs = [ pkgconfig openssl stdenv.cc.libc.static ] ++
                (if libuuid == null
                 then []
                 else [ (stdenv.lib.overrideDerivation libuuid
                          (args: { configureFlags = args.configureFlags + " --enable-static"; })) ]);

  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "vboot_reference for: ${stdenv.system} not supported!";

  buildPhase = ''
    make ARCH=${arch} `pwd`/build/cgpt/cgpt
    make ARCH=${arch} `pwd`/build/utility/vbutil_kernel
    make ARCH=${arch} `pwd`/build/utility/vbutil_key
    make ARCH=${arch} `pwd`/build/utility/vbutil_keyblock
    make ARCH=${arch} `pwd`/build/utility/vbutil_firmware
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/cgpt/cgpt $out/bin
    cp build/utility/vbutil_kernel $out/bin
    cp build/utility/vbutil_key $out/bin
    cp build/utility/vbutil_keyblock $out/bin
    cp build/utility/vbutil_firmware $out/bin
  '';

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
