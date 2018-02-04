{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.8.1";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "13pawz031pzyc4ap5kk229cmzj0qjx5x0j1mw7jhwhc4w4ximvl3";
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
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm ];
  };
}
