{ stdenv }:

# this tool only exists on darwin
assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "rez";

  src = "/usr/bin/Rez";

  unpackPhase = "true";
  configurePhase = "true";
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s $src "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Compiles resources";
    homepage    = "https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/Rez.1.html";
    maintainers = [ maintainers.lnl7 ];
    platforms   = platforms.darwin;

    longDescription = ''
      The Rez tool compiles the resource fork of a file according to the textual description contained in
      the resource description files. These resource description files must contain both the type
      declarations and the resource definitions needed to compile the resources. This data can come
      directly from the resource description files.
    '';
  };
}
