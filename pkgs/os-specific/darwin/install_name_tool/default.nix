{ stdenv }:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "install_name_tool";
  src = "/usr/bin/install_name_tool";

  unpackPhase = "true";
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"/bin
    ln -s "$src" "$out"/bin
  '';

  meta = with stdenv.lib; {
    description = "Change dynamic shared library install names";
    homepage    = https://developer.apple.com/library/mac/documentation/Darwin/Reference/Manpages/man1/install_name_tool.1.html;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.darwin;

    longDescription = ''
      Install_name_tool changes the dynamic shared library install names and or
      adds, changes or deletes the rpaths recorded in a Mach-O binary.
    '';
  };
}

