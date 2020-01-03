{ stdenv, fetchurl, autoreconfHook }:

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

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = https://nixos.org/patchelf.html;
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
