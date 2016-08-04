{stdenv, fetchurl, tetex, unzip}:

stdenv.mkDerivation rec {
  name = "tex4ht-1.0.2009_06_11_1038";

  src = fetchurl {
    url = "http://tug.org/applications/tex4ht/tex4ht.zip";
    sha256 = "15gj18ihds6530af42clpa4zskak5kah9wzs2hd19a9ymwjsccd6";
  };

  buildInputs = [ tetex unzip ];

  hardeningDisable = [ "format" ];

  buildPhase = ''
    cd src
    for f in tex4ht t4ht htcmd ; do
      # -DENVFILE="$out/share/texmf-nix/tex4ht/base/unix/tex4ht.env"
      ''${CC:-gcc} -o $f $f.c -I${tetex}/include -L${tetex}/lib  -DHAVE_DIRENT_H -DHAVE_DIRENT_H -DKPATHSEA -lkpathsea
    done
    cd -
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in src/tex4ht src/t4ht src/htcmd "bin/unix/"*; do
      mv $f $out/bin/
    done
    mv texmf $out/texmf-dist
  '';

  meta = {
    homepage = "http://tug.org/tex4ht/";
    description = "A system to convert (La)TeX documents to HTML and various other formats";
    license = stdenv.lib.licenses.lppl12;
    platforms = stdenv.lib.platforms.unix;
  };
}
