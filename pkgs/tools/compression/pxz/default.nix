{ stdenv, fetchgit, xz, lzma }:

let name = "pxz";
    version = "4.999.9beta+git";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchgit {
    url = "https://github.com/jnovy/pxz.git";
    rev = "ae808463c2950edfdedb8fb49f95006db0a18667";
    sha256 = "0na2kw8cf0qd8l1aywlv9m3xrxnqlcwxfdwp3f7x9vxwqx3k32kc";
  };

  buildInputs = [ lzma ];

  patches = [ ./_SC_ARG_MAX.patch ];

  buildPhase = ''
    gcc -o pxz pxz.c -llzma \
        -fopenmp -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -O2 \
        -DPXZ_BUILD_DATE=\"nixpkgs\" \
        -DXZ_BINARY=\"${xz.bin}/bin/xz\" \
        -DPXZ_VERSION=\"${version}\"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pxz $out/bin
    cp pxz.1 $out/share/man/man1
  '';

  meta = {
    homepage = https://jnovy.fedorapeople.org/pxz/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [pashev];
    description = ''Parallel XZ is a compression utility that takes advantage of
      running LZMA compression of different parts of an input file on multiple
      cores and processors simultaneously. Its primary goal is to utilize all
      resources to speed up compression time with minimal possible influence
      on compression ratio'';
    platforms = with stdenv.lib.platforms; linux;
  };
}
