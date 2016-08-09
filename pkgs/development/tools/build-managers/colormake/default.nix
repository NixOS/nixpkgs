{stdenv, fetchgit, perl}:

stdenv.mkDerivation rec {
  name = "colormake-${version}";
  version = "2.1.0";

  buildInputs = [perl];

  src = fetchgit {
    url = https://github.com/pagekite/Colormake.git;
    rev = "66544f40d";
    sha256 = "8e714c5540305d169989d9387dbac47b8b9fb2cfb424af7bcd412bfe684dc6d7";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -fa colormake.pl colormake colormake-short clmake clmake-short $out/bin
  '';

  meta = {
    description = "Simple wrapper around make to colorize the output";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
