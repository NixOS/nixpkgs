{stdenv, fetchurl, tetex, unzip}:

stdenv.mkDerivation rec {
  name = "tex4ht-1.0.2009_06_11_1038";

  src = fetchurl {
    url = "http://www.tug.org/applications/tex4ht/tex4ht.zip";
    # http://www.cse.ohio-state.edu/~gurari/TeX4ht/fix/${name}.tar.gz";
    sha1 = "2970cec5f4afc9039b82d6a4210f21d70ded2f5a";
  };

  buildInputs = [ tetex unzip ];

  buildPhase = ''
    cd src
    for f in tex4ht t4ht htcmd ; do
      # -DENVFILE="$out/share/texmf-nix/tex4ht/base/unix/tex4ht.env"
      gcc -o $f $f.c -I${tetex}/include -L${tetex}/lib  -DHAVE_DIRENT_H -DHAVE_DIRENT_H -DKPATHSEA -lkpathsea
    done
    cd -
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in src/tex4ht src/t4ht src/htcmd bin/unix/*; do # */
      mv $f $out/bin/.
    done

    mkdir -p $out/share
    cp -r texmf $out/share/.
  '';

  meta = {
    homepage = http://www.cse.ohio-state.edu/~gurari/TeX4ht/mn.html;
    # LaTeX Project Public License
    license = "LPPL";
  };
}