{ stdenv, fetchurl, autoreconfHook, lib }:

stdenv.mkDerivation rec {
  name = "patchelf-${version}";
  version = "0.10";

  src = fetchurl {
    url = "https://nixos.org/releases/patchelf/${name}/${name}.tar.bz2";
    sha256 = "1wzwvnlyf853hw9zgqq5522bvf8gqadk8icgqa41a5n7593csw7n";
  };

  # Drop test that fails on musl (?)
  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  # Aarch64 supports page sizes up to 64K. GCC, binutils, etc. generate ELF
  # files with segments aligned to 64K so that the generated binaries can run
  # on systems with any page size configuration. However, patchelf defaults to
  # "whatever the builder's kernel is using", which is currently 4K.
  #
  # Match the default from the rest of the toolchain ecosystem to support
  # kernels with larger page sizes.
  configureFlags = lib.optional stdenv.isAarch64 "--with-page-size=65536";

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/NixOS/patchelf/blob/master/README";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
