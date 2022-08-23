{ lib, stdenv, fetchgit, pkg-config, libbpf, cmake, elfutils, zlib, argp-standalone, musl-obstack }:

stdenv.mkDerivation rec {
  pname = "pahole";
  version = "1.23";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "v${version}";
    sha256 = "sha256-Dt3ZcUfjwdtTTv6qRFRgwK5GFWXdpN7fvb9KhpS1O94=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ elfutils zlib libbpf ]
    ++ lib.optional stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  # Put libraries in "lib" subdirectory, not top level of $out
  cmakeFlags = [ "-D__LIB=lib" "-DLIBBPF_EMBEDDED=OFF" ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Pahole and other DWARF utils";
    license = licenses.gpl2Only;

    platforms = platforms.linux;
    maintainers = with maintainers; [ bosu martinetd ];
  };
}
