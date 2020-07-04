{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "go-bindata";
  version = "unstable-2015-10-23";

  goPackagePath = "github.com/jteeuwen/go-bindata";

  src = fetchFromGitHub {
    owner = "jteeuwen";
    repo = "go-bindata";
    rev = "a0ff2567cfb70903282db057e799fd826784d41d";
    sha256 = "0d6zxv0hgh938rf59p1k5lj0ymrb8kcps2vfrb9kaarxsvg7y69v";
  };

  excludedPackages = "testdata";

  meta = with stdenv.lib; {
    homepage = "https://github.com/jteeuwen/go-bindata";
    description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.cc0;
    platforms = platforms.all;
  };
}
