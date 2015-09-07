{ stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation {
  name = "pahole-head";
  src = fetchgit {
    url = https://git.kernel.org/pub/scm/devel/pahole/pahole.git;
    sha256 = "05f8a14ea6c200c20e9c6738593b38e4ced73a9cef86499ccd7af910eb9b74b3";
    rev = "1decb1bc4a412a0902b7b25190d755a875022d03";
  };
  buildInputs = [ cmake elfutils zlib ];

  postInstall = ''
    for p in $out/bin/*; do
      rpath=`patchelf --print-rpath $p || true`:$out
      patchelf --set-rpath "$rpath" $p || true
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/cgit/devel/pahole/pahole.git/;
    description = "Pahole and other DWARF utils";
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = [ maintainers.bosu ];
  };
}
