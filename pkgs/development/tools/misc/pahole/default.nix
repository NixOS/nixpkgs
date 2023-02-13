{ lib, stdenv, fetchgit, pkg-config, libbpf, cmake, elfutils, zlib, argp-standalone, musl-obstack }:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.24";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "v${version}";
    sha256 = "sha256-OPseVKt5kIKgK096+ufKrWMS1E/7Z0uxNqCMN6wKfKg=";
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
