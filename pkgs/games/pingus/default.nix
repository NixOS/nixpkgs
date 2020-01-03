{stdenv, fetchurl, fetchpatch, scons, SDL, SDL_image, boost, libpng, SDL_mixer
, pkgconfig, libGLU, libGL}:
let
  s = # Generated upstream information
  {
    baseName="pingus";
    version="0.7.6";
    name="pingus-0.7.6";
    hash="0q34d2k6anzqvb0mf67x85q92lfx9jr71ry13dlp47jx0x9i573m";
    url="http://pingus.googlecode.com/files/pingus-0.7.6.tar.bz2";
    sha256="0q34d2k6anzqvb0mf67x85q92lfx9jr71ry13dlp47jx0x9i573m";
  };
in
stdenv.mkDerivation {
  inherit (s) name version;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [scons SDL SDL_image boost libpng SDL_mixer libGLU libGL];
  src = fetchurl {
    inherit (s) url sha256;
  };
  patches = [
    # fix build with gcc7
    (fetchpatch {
      url = https://github.com/Pingus/pingus/commit/df6e2f445d3e2925a94d22faeb17be9444513e92.patch;
      sha256 = "0nqyhznnnvpgfa6rfv8rapjfpw99b67n97jfqp9r3hpib1b3ja6p";
    })
  ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  dontUseSconsInstall = true;
  meta = {
    inherit (s) version;
    description = ''A puzzle game with mechanics similar to Lemmings'';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.raskin];
    license = stdenv.lib.licenses.gpl3;
  };
}
