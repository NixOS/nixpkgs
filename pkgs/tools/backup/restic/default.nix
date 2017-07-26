{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.7.0";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "1whzzma2c199i604qy1a807zhi8qgri1r9bbxl5l7wlfh7x0n6sd";
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
