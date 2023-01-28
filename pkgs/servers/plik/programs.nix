{ lib, buildGoModule, fetchFromGitHub, fetchurl, makeWrapper, runCommand }:

let
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
    sha256 = "sha256-Xfk7+60iB5/qJh/6j6AxW0aKXuzdINRfILXRzOFejW4=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://plik.root.gg/";
    description = "Scalable & friendly temporary file upload system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.mit;
  };

  postPatch = ''
    substituteInPlace server/common/version.go \
      --replace '"0.0.0"' '"${version}"'
  '';

in
{

  plik = buildGoModule {
    pname = "plik";
    inherit version meta src vendorSha256 postPatch;

    subPackages = [ "client" ];
    postInstall = ''
      mv $out/bin/client $out/bin/plik
    '';
  };

  plikd-unwrapped = buildGoModule {
    pname = "plikd-unwrapped";
    inherit version src vendorSha256 postPatch;

    subPackages = [ "server" ];
    postFixup = ''
      mv $out/bin/server $out/bin/plikd
    '';
  };
}
