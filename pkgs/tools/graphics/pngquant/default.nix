{ stdenv, fetchgit, libpng }:

stdenv.mkDerivation rec {
  name = "pngquant-${version}";
  version = "2.0.1";

  src = fetchgit {
    url = https://github.com/pornel/pngquant.git;
    rev = "refs/tags/${version}";
    sha256 = "00mrv9wgxbwy517l8i4n7n3jpzirjdgi0zass3wj29i7xyipwlhf";
  };

  buildInputs = [ libpng ];

  preInstall = ''
    mkdir -p $out/bin
    export PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pornel/pngquant;
    description = "pngquant converts 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    platforms = platforms.all;
    license = licenses.bsd2; # Not exactly bsd2, but alike
    broken = true;
  };
}
