{ lib, stdenv, fetchgit, pkg-config, libbpf, cmake, elfutils, zlib, argp-standalone, musl-obstack }:

stdenv.mkDerivation rec {
  pname = "pahole";
  # Need a revision that supports DW_TAG_unspecified_type(0x3b).
  # Was added after 1.24 release in a series of changes.
  # Can switch back to release tags once 1.25 is cut.
  version = "1.24-unstable-2022-11-24";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "02d67c51765dfbd5893087da63744c864c7cc9e0";
    hash = "sha256-hKc8UKxPtEM2zlYmolSt1pXJKNRt4wC/Uf+dP/Sb7+s=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ elfutils zlib libbpf ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" "-DLIBBPF_EMBEDDED=OFF" ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu martinetd ];
  };
}
