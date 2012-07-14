{stdenv, fetchurl, binutilsCross ? null, gccCross ? null, onlyHeaders ? false}:

let
  name = "mingw-w64-2.0.3";
in
stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v2.0.3.tar.gz";
    sha256 = "043jk6z90f9pxs9kfn6ckh2vlnbgcv6yfbp5ybahrj3z58dcijp5";
  };

  # I don't know what's that $host directory about, I put the
  # files inside include as usual.
  postInstall = ''
    rmdir $out/include
    mv $out/x86_64-w64-mingw32/* $out
    rm -R $out/x86_64-w64-mingw32
  '';
} //
(if onlyHeaders then {
  name = name + "-headers";
  preConfingure = ''
    cd mingw-w64-headers
  '';
  configureFlags = "--without-crt --host=x86_64-w64-mingw32";
} else {
  buildInputs = [ gccCross binutilsCross ];

  crossConfig = gccCross.crossConfig;

  dontStrip = true;
})
)
