{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.6.0";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "0kjk8fyfmbnh2jayfjq4ggkc99rh02jkv8gvqcpyqnw3dxznwrk2";
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
