{ stdenv, fetchurl, libX11, perl, libXtst, xextproto, libXi, libXinerama }:

let version = "2.20110530.1"; in
stdenv.mkDerivation {
  name = "xdotool-${version}";
  src = fetchurl {
    url = "http://semicomplete.googlecode.com/files/xdotool-${version}.tar.gz";
    sha256 = "0rxggg1cy7nnkwidx8x2w3c5f3pk6dh2b6q0q7hp069r3n5jrd77";
  };

  buildInputs = [ libX11 perl libXtst xextproto libXi libXinerama ];

  configurePhase = ''
    export makeFlags="PREFIX=$out";
  '';

  meta = {
    homepage = http://www.semicomplete.com/projects/xdotool/;
    description = "Fake keyboard/mouse input, window management, and more";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
