{ stdenv, substituteAll, coreutils, which }:

stdenv.mkDerivation rec {
  name = "lesspipe";

  buildCommand = ''
    install -Dm755 $script $out/bin/lesspipe
    ln -s $out/bin/lesspipe $out/bin/lessfile
    mkdir -p $out/share/man/man1
    gzip -c $manual > $out/share/man/man1/lesspipe.1.gz
  '';

  script = substituteAll {
    src = ./lesspipe;
    inherit coreutils which;
  };

  manual = ./lesspipe.1;

  meta = with stdenv.lib; {
    description = "Input preprocessor for less";
    longDescription = ''
      lessfile and lesspipe are programs that can be used to modify the way
      the contents of a file are displayed in less. What this means is that
      less can automatically open up tar files, uncompress gzipped files,
      and even display something reasonable for graphics files.
    '';
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
