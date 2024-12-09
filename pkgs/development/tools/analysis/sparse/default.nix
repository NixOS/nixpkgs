{ callPackage, fetchurl, lib, stdenv, gtk3, pkg-config, libxml2, llvm, perl, sqlite }:

let
  GCC_BASE = "${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.uname.processor}-unknown-linux-gnu/${stdenv.cc.cc.version}";
in stdenv.mkDerivation rec {
  pname = "sparse";
  version = "0.6.4";

  src = fetchurl {
    url = "mirror://kernel/software/devel/sparse/dist/${pname}-${version}.tar.xz";
    sha256 = "sha256-arKLSZG8au29c1UCkTYKpqs99B9ZIGqb3paQIIpuOHw=";
  };

  preConfigure = ''
    sed -i 's|"/usr/include"|"${stdenv.cc.libc.dev}/include"|' pre-process.c
    sed -i 's|qx(\$ccom -print-file-name=)|"${GCC_BASE}"|' cgcc
    makeFlags+=" PREFIX=$out"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 libxml2 llvm perl sqlite ];
  doCheck = true;
  buildFlags = [ "GCC_BASE:=${GCC_BASE}" ];

  # Test failures with "fortify3" on, such as:
  # +*** buffer overflow detected ***: terminated
  # +Aborted (core dumped)
  # error: Actual exit value does not match the expected one.
  # error: expected 0, got 134.
  # error: FAIL: test 'bool-float.c' failed
  hardeningDisable = [ "fortify3" ];

  passthru.tests = {
    simple-execution = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Semantic parser for C";
    homepage    = "https://git.kernel.org/pub/scm/devel/sparse/sparse.git/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice jkarlson ];
  };
}
