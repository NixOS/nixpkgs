{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-F7ehl7Q/66ah6/N06U8Ld3bUjuF5tpJlNS/aWEorQaI=";
  };

  vendorHash = "sha256-FvTDqGr3B05osuJvLj7J04JMeamZc/X6YeLY24ej7Ak=";

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "webdav";
  };
}
