{ stdenv, fetchFromGitHub, makeWrapper, lrzsz, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "picocom-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "npat-efault";
    repo = "picocom";
    rev = version;
    sha256 = "1vvjydqf0ax47nvdyyl67jafw5b3sfsav00xid6qpgia1gs2r72n";
  };

  buildInputs = [ makeWrapper ]
    ++ optionals stdenv.isDarwin [ IOKit ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp picocom $out/bin
    cp picocom.1 $out/share/man/man1

    wrapProgram $out/bin/picocom \
      --prefix PATH ":" "${lrzsz}/bin"
  '';

  meta = {
    description = "Minimal dumb-terminal emulation program";
    homepage = https://github.com/npat-efault/picocom/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
