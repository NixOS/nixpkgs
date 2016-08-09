{ stdenv 
, fetchgit
}:
stdenv.mkDerivation rec {
  name = "argtable-${version}";
  version = "3.0.1";

  src = fetchgit {
    url = https://github.com/argtable/argtable3.git;
    rev = "de93cfd85f755250285b337cba053a709a270721";
    sha256 = "0fbvk78s3dwryrzgafdra0lb8w7lb873c6xgldl94ps9828x85i3";
  };

  buildPhase = ''
    gcc -shared -o libargtable3.so -fPIC argtable3.c

    pushd tests
    make
    popd
  '';

  installPhase = ''
    mkdir -p $out/include
    cp argtable3.h $out/include

    mkdir -p $out/lib
    cp libargtable3.so $out/lib

    mkdir -p $out/src
    cp argtable3.c $out/src
    cp -r examples $out/src
    ln -s $out/include/argtable3.h $out/src/argtable3.h
  '';

  meta = with stdenv.lib; {
    homepage = http://www.argtable.org/;
    description = "A Cross-Platform, Single-File, ANSI C Command-Line Parsing Library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ artuuge ];
  };
}
