{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "prettyping-${version}";
  version = "1.0.1";

  src = fetchgit {
    url = "https://github.com/denilsonsa/prettyping";
    rev = "e8d7538b8742b27cffe28e9dfe13d1d1a12288e3";
    sha256 = "05vfaq9y52z40245j47yjk1xaiwrazv15sgjq64w91dfyahjffxf";
    fetchSubmodules = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    chmod +x $src/prettyping
    install $src/prettyping $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A wrapper around the standard ping tool, making the output prettier, more colorful, more compact, and easier to read.";
    longDescription = ''
      `prettyping` runs the standard ping in background and parses its output, showing ping responses in a graphical way at the terminal (by using colors and Unicode characters). Don’t have support for UTF-8 in your terminal? No problem, you can disable it and use standard ASCII characters instead. Don’t have support for colors? No problem, you can also disable them.
    '';
    homepage = http://denilson.sa.nom.br/prettyping/;
    license = licenses.mit;
    maintainers = [ maintainers.stites ];
    platforms = platforms.all;
  };
}


