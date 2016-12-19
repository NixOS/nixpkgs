{ stdenv, fetchgit, wxGTK, libX11, readline }:

let
  # BOSSA needs a "bin2c" program to embed images.
  # Source taken from:
  # http://wiki.wxwidgets.org/Embedding_PNG_Images-Bin2c_In_C
  bin2c = stdenv.mkDerivation {
    name = "bossa-bin2c";
    src = ./bin2c.c;
    unpackPhase = "true";
    buildPhase = ''cc $src -o bin2c'';
    installPhase = ''mkdir -p $out/bin; cp bin2c $out/bin/'';
  };

in
stdenv.mkDerivation rec {
  name = "bossa-2014-08-18";

  src = fetchgit {
    url = https://github.com/shumatech/BOSSA;
    rev = "0f0a41cb1c3a65e909c5c744d8ae664e896a08ac"; /* arduino branch */
    sha256 = "0xg79kli1ypw9zyl90mm6vfk909jinmk3lnl8sim6v2yn8shs9cn";
  };

  patches = [ ./bossa-no-applet-build.patch ];

  nativeBuildInputs = [ bin2c ];
  buildInputs = [ wxGTK libX11 readline ];

  # Explicitly specify targets so they don't get stripped.
  makeFlags = [ "bin/bossac" "bin/bossash" "bin/bossa" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/bossa{c,sh,} $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A flash programming utility for Atmel's SAM family of flash-based ARM microcontrollers";
    longDescription = ''
      BOSSA is a flash programming utility for Atmel's SAM family of
      flash-based ARM microcontrollers. The motivation behind BOSSA is
      to create a simple, easy-to-use, open source utility to replace
      Atmel's SAM-BA software. BOSSA is an acronym for Basic Open
      Source SAM-BA Application to reflect that goal.
    '';
    homepage = http://www.shumatech.com/web/products/bossa;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
