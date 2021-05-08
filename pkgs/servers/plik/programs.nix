{ lib, buildGoModule, fetchFromGitHub, fetchurl, makeWrapper, runCommand }:

let
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
    sha256 = "C/1Uwjsqd9n3WSXlnlq9K3EJHkLOSavS9cPqF2UqmGo=";
  };

  vendorSha256 = "klmWXC3tkoOcQHhiQZjR2C5jqaRJqMQOLtVxZ0cFq/Y=";

  meta = with lib; {
    homepage = "https://plik.root.gg/";
    description = "Scalable & friendly temporary file upload system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.mit;
  };
in {

  plik = buildGoModule {
    pname = "plik";
    inherit version meta src vendorSha256;

    subPackages = [ "client" ];
    postInstall = ''
      mv $out/bin/client $out/bin/plik
    '';
  };

  plikd-unwrapped = buildGoModule {
    pname = "plikd-unwrapped";
    inherit version src vendorSha256;

    subPackages = [ "server" ];
    postFixup = ''
      mv $out/bin/server $out/bin/plikd
    '';
  };
}
