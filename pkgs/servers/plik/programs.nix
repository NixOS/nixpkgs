{ lib, buildGoModule, fetchFromGitHub, fetchurl, makeWrapper, runCommand }:

let
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
    sha256 = "sha256-YT+hIh68foHD+WcprFL+Z1eddUYmay0IJ3YGGy7NZbY=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://plik.root.gg/";
    description = "Scalable & friendly temporary file upload system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.mit;
  };
in
{

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
