{ lib
, stdenv
, fetchzip
, pkg-config
, libbpf
, cmake
, elfutils
, zlib
, argp-standalone
, musl-obstack
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.25";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${version}.tar.gz";
    hash = "sha256-s0YVT2UnMSO8jS/4XCt06wNPV4czHH6bmZRy/snO3jg=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ elfutils zlib libbpf ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  patches = [ ./threading-reproducibility.patch ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" "-DLIBBPF_EMBEDDED=OFF" ];

  passthru.tests = {
    inherit (nixosTests) bpf;
  };

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu martinetd ];
  };
}
