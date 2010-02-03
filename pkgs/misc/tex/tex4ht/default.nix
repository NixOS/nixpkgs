{stdenv, fetchurl, tetex}:

stdenv.mkDerivation rec {
  name = "tex4ht-1.0.2009_06_11_1038";

  src = fetchurl {
    url = "http://www.cse.ohio-state.edu/~gurari/TeX4ht/fix/${name}.tar.gz";
    sha1 = "7d46488059316dec3234b6478cd0d2ca8f4d110f";
  };

  buildInputs = [ tetex ];

  buildPhase = ''
    cd src
    for f in tex4ht t4ht htcmd ; do
      # -DENVFILE="$out/share/texmf-nix/tex4ht/base/unix/tex4ht.env"
      gcc -o $f $f.c -I${tetex}/include -L${tetex}/lib  -DHAVE_DIRENT_H -DHAVE_DIRENT_H -DKPATHSEA -lkpathsea
    done
    cd -
  '';

  installPhase = ''
    ensureDir $out/bin
    for f in src/tex4ht src/t4ht src/htcmd bin/unix/*; do # */
      mv $f $out/bin/.
    done

    ensureDir $out/share
    cp -r texmf $out/share/.
  '';

  meta = {
    homepage = http://www.cse.ohio-state.edu/~gurari/TeX4ht/mn.html;
    # LaTeX Project Public License
    license = "LPPL";
  };
}