{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.6.1";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "1rp4s1gh07j06457rhl4r0qnxqn0h7n4i8k50akdr87nwyikkn17";
  };

  buildPhase = ''
    cd go/src/${goPackagePath}
    go run build.go
  '';

  installPhase = ''
    mkdir -p $bin/bin/
    cp restic $bin/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://restic.github.io;
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm ];
  };
}
