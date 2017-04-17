{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.3.3";
  name = "rhash-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rhash/${name}-src.tar.gz";
    sha1 = "0981bdc98ba7ef923b1a6cd7fd8bb0374cff632e";
    sha256 = "0nii6p4m2x8rkaf8r6smgfwb1q4hpf117kkg64yr6gyqgdchnljv";
  };

  installFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

  # we build the static library because of two makefile bugs
  # * .h files installed for static library target only
  # * .so.0 -> .so link only created in the static library install target
  buildPhase = ''
    make lib-shared lib-static build-shared
  '';

  # we don't actually want the static library, so we remove it after it
  # gets installed
  installPhase = ''
    make DESTDIR="$out" PREFIX="/" install-shared install-lib-shared install-lib-static
    rm $out/lib/librhash.a
  '';

  meta = with stdenv.lib; {
    homepage = http://rhash.anz.ru;
    description = "Console utility and library for computing and verifying hash sums of files";
    platforms = platforms.linux;
    maintainers = [ maintainers.andrewrk ];
  };
}
