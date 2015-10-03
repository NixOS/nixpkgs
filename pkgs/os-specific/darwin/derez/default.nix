{ stdenv }:

# this tool only exists on darwin
assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "derez";

  src = "/usr/bin/DeRez";

  unpackPhase = "true";
  configurePhase = "true";
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s $src "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Decompiles resources";
    homepage    = "https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/DeRez.1.html";
    maintainers = [ maintainers.lnl7 ];
    platforms   = platforms.darwin;

    longDescription = ''
      The DeRez tool decompiles the resource fork of resourceFile according to the type declarations
      supplied by the type declaration files. The resource description produced by this decompilation
      contains the resource definitions (resource and data statements) associated with these type
      declarations. If for some reason it cannot reproduce the appropriate resource statements, DeRez
      generates hexadecimal data statements instead.
    '';
  };
}
