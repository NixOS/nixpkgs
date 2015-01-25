{ stdenv, fetchurl, ncurses }:

let version = "4.6.patch6"; in
stdenv.mkDerivation rec {
  name = "clex-${version}";

  src = fetchurl {
    sha256 = "0bqa2hc9721d62cfsy5c7a5pzgh9b4px7g4q60xlybkwll19qbbp";
    url = "${meta.homepage}/download/${name}.tar.gz";
  };

  meta = with stdenv.lib; {
    description = "File manager with full-screen terminal interface";
    longDescription = ''
      CLEX (pronounced KLEKS) displays directory contents including the file
      status details and provides features like command history, filename
      insertion, or name completion in order to help users to create commands
      to be executed by the shell. There are no built-in commands, CLEX is an
      add-on to your favorite shell.
    '';
    homepage = http://www.clex.sk;
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;
}
