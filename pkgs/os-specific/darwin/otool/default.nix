{ stdenv }:

assert stdenv.isDarwin;
/*  this tool only exists on darwin
    NOTE: it might make sense to compile this from source (maybe it even works for non-darwin)
    I see cctools source is under GPL2+ as well as APSL 2.0
    http://opensource.apple.com/release/developer-tools-46/
*/

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
    # TODO license     = with licenses; [ apsl20 gpl2Plus ];
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

