{ stdenv }:

# this tool only exists on darwin
assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "otool";

  src = "/usr/bin/otool";

  unpackPhase = "true";
  configurePhase = "true";
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s $src "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Object file displaying tool";
    homepage    = https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/otool.1.html;
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.darwin;

    longDescription = ''
      The otool command displays specified parts of object files or libraries.
      If the, -m option is not used, the file arguments may be of the form
      libx.a(foo.o), to request information about only that object file and not
      the entire library.
    '';
  };
}

