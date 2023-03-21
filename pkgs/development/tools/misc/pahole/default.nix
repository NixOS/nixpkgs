{ lib, stdenv, fetchzip, pkg-config, libbpf, cmake, elfutils, zlib, argp-standalone, musl-obstack }:

stdenv.mkDerivation rec {
  pname = "pahole";
  # Can switch back to release tags if they can build linux_testing.
  version = "1.24-unstable-2023-03-02";
  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-a9498899109d3be14f17abbc322a8f55a1067bee.tar.gz";
    sha256 = "xEKA6Fz6NaxNqSggvgswCU+7LlezGSNrK7cmt2JYv1Y=";
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
