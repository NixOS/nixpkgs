{ stdenv }:

# this tool only exists on darwin
assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "setfile";

  src = "/usr/bin/SetFile";

  unpackPhase = "true";
  configurePhase = "true";
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s $src "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Set attributes of files and directories";
    homepage    = "http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/setfile.1.html";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.darwin;

    longDescription = ''
      SetFile is a tool to set the file attributes on files in an HFS+
      directory. It attempts to be similar to the setfile command in MPW. It can
      apply rules to more than one file with the options apply- ing to all files
      listed.
    '';
  };
}
