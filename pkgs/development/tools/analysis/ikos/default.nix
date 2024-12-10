{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  tbb,
  gmp,
  llvm,
  clang,
  sqlite,
  python3,
  ocamlPackages,
  mpfr,
  ppl,
  doxygen,
  graphviz,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      pygments
    ]
  );
in

stdenv.mkDerivation rec {
  pname = "ikos";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "NASA-SW-VnV";
    repo = "ikos";
    rev = "v${version}";
    hash = "sha256-scaFkUhCkIi41iR6CGPbEndzXkgqTKMb3PDNvhgVbCE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/NASA-SW-VnV/ikos/commit/2e647432427b3f0dbb639e0371d976ab6406f290.patch";
      hash = "sha256-ffzjlqEp4qp76Kwl5zpyQlg/xUMt8aLDSSP4XA4ndS8=";
    })
    # Fix build with GCC 13
    # https://github.com/NASA-SW-VnV/ikos/pull/262
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/NASA-SW-VnV/ikos/commit/73c816641fb9780f0d3b5e448510363a3cf21ce2.patch";
      hash = "sha256-bkeSAtxrL+z+6QNiGOWSg7kN8XiZqMxlJiu5Dquhca0=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    tbb
    gmp
    clang
    llvm
    sqlite
    python
    ocamlPackages.apron
    mpfr
    ppl
    doxygen
    graphviz
  ];

  cmakeFlags = [ "-DAPRON_ROOT=${ocamlPackages.apron}" ];

  postBuild = "make doc";

  meta = with lib; {
    homepage = "https://github.com/NASA-SW-VnV/ikos";
    description = "Static analyzer for C/C++ based on the theory of Abstract Interpretation";
    license = licenses.nasa13;
    maintainers = with maintainers; [ atnnn ];
  };
}
