{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-bindata-${version}";
  version = "20151023-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "a0ff2567cfb70903282db057e799fd826784d41d";
  
  goPackagePath = "github.com/jteeuwen/go-bindata";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/jteeuwen/go-bindata";
    sha256 = "0d6zxv0hgh938rf59p1k5lj0ymrb8kcps2vfrb9kaarxsvg7y69v";
  };

  excludedPackages = "testdata";

  meta = with stdenv.lib; {
    homepage    = "https://github.com/jteeuwen/go-bindata";
    description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.cc0 ;
    platforms   = platforms.all;
  };
}
