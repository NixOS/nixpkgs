{ stdenv }:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "ibtool";
  src = "/usr/bin/ibtool";

  unpackPhase = "true";
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"/bin
    ln -s "$src" "$out"/bin
  '';

  meta = with stdenv.lib; {
    platforms   = platforms.darwin;
  };
}
