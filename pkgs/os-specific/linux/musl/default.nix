{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.15";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "1ymhxkskivzph0q34zadwfglc5gyahqajm7chqqn2zraxv3lgr4p";
  };

  enableParallelBuilding = true;

  # required to avoid busybox segfaulting on startup when invoking
  # nix-build "<nixpkgs/pkgs/stdenv/linux/make-bootstrap-tools.nix>"
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "--disable-gcc-wrapper"
  ];

  patches = [
    # CVE-2016-8859: http://www.openwall.com/lists/oss-security/2016/10/19/1
    (fetchpatch {
      url = "https://git.musl-libc.org/cgit/musl/patch/?id=c3edc06d1e1360f3570db9155d6b318ae0d0f0f7";
      sha256 = "15ih0aj27lz4sgq8r5jndc3qy5gz3ciraavrqpp0vw8h5wjcsb9v";
    })
  ];

  dontDisableStatic = true;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
