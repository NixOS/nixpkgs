{stdenv, fetchgit, perl}:

assert stdenv ? glibc;

let
  rev = "7a9a5c48ede207eec881";
in
stdenv.mkDerivation {
  name = "ninka-"+rev;
  src = fetchgit {
    url = http://github.com/dmgerman/ninka.git;
    inherit rev;
    sha256 = "3e877fadf074b9c5abfe36ff10b7e332423d1d4c5b17accc5586c7cffdb2c7dd";
  };
  
  buildInputs = [ perl ];
  
  installPhase = ''
    ensureDir $out/bin
    cp ninka.pl $out/bin
    cp -av {extComments,splitter,filter,senttok,matcher} $out/bin
    
    cd comments
    tar xfvz comments.tar.gz
    cd comments
    sed -i -e "s|/usr/local/bin|$out/bin|" -e "s|/usr/local/man|$out/share/man|" Makefile    
    ensureDir $out/{bin,share/man/man1}
    make install
    
    # Dirty
    #patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/comments
    #patchelf --set-rpath ${stdenv.glibc}/lib:${stdenv.gcc}/lib $out/bin/comments
  '';
  
  meta = {
    license = "AGPLv3+";
    description = "A sentence based license detector";
  };
}
