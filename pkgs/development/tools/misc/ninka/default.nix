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
  
  buildPhase = ''
    cd comments
    tar xfvz comments.tar.gz
    cd comments
    sed -i -e "s|/usr/local/bin|$out/bin|g" -e "s|/usr/local/man|$out/share/man|g" Makefile
    make
  '';
  
  installPhase = ''
    cd ../..
    mkdir -p $out/bin
    cp ninka.pl $out/bin
    cp -av {extComments,splitter,filter,senttok,matcher} $out/bin
    
    cd comments/comments    
    mkdir -p $out/{bin,share/man/man1}
    make install    
  '';
  
  meta = {
    license = "AGPLv3+";
    description = "A sentence based license detector";
  };
}
