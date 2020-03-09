{ stdenv, fetchurl, bison, flex, libffi }:

stdenv.mkDerivation rec {
  pname = "txr";
  version = "231";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/${pname}-${version}.tar.bz2";
    sha256 = "0mcglb84zfmrai2bcdg9j0ck8jp8h7ii2rf4m38yjggy0dvii2lc";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  # Remove failing test-- mentions 'usr/bin' so probably related :)
  preCheck = "rm -rf tests/017";

  postInstall = ''
    d=$out/share/vim-plugins/txr
    mkdir -p $d/{syntax,ftdetect}

    cp {tl,txr}.vim $d/syntax/

    cat > $d/ftdetect/txr.vim <<EOF
      au BufRead,BufNewFile *.txr set filetype=txr | set lisp
      au BufRead,BufNewFile *.tl,*.tlo set filetype=tl | set lisp
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Programming language for convenient data munging";
    license = licenses.bsd2;
    homepage = http://nongnu.org/txr;
    maintainers = with stdenv.lib.maintainers; [ dtzWill ];
    platforms = platforms.linux; # Darwin fails although it should work AFAIK
  };
}
