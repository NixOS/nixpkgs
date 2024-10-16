{ lib, fetchFromGitHub, buildGo123Module }:

buildGo123Module rec {
  pname = "webdav";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-fZhzU2Buy/MScJNZeq/bMU5WhYCVVMaOF63SODe/+sQ=";
  };

  vendorHash = "sha256-d8WauJ1i429dr79iHgrbFRZCmx+W6OobSINy8aNGG6w=";

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "webdav";
  };
}
