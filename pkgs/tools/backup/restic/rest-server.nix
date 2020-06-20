{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "restic-rest-server";
  version = "0.9.7";

  goPackagePath = "github.com/restic/rest-server";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    sha256 = "1g47ly1pxwn0znbj3v5j6kqhn66d4wf0d5gjqzig75pzknapv8qj";
  };

  buildPhase = ''
    cd go/src/${goPackagePath}
    go run build.go
  '';

  installPhase = ''
    install -Dt $out/bin rest-server
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A high performance HTTP server that implements restic's REST backend API";
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
