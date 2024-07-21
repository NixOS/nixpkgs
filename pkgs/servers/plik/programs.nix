{ lib, buildGoModule, fetchFromGitHub, makeWrapper, runCommand }:

let
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
    hash = "sha256-WCtfkzlZnyzZDwNDBrW06bUbLYTL2C704Y7aXbiVi5c=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://plik.root.gg/";
    description = "Scalable & friendly temporary file upload system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.mit;
    mainProgram = "plik";
  };

  postPatch = ''
    substituteInPlace server/common/version.go \
      --replace '"0.0.0"' '"${version}"'
  '';

in
{

  plik = buildGoModule {
    pname = "plik";
    inherit version meta src vendorHash postPatch;

    subPackages = [ "client" ];
    postInstall = ''
      mv $out/bin/client $out/bin/plik
    '';
  };

  plikd-unwrapped = buildGoModule {
    pname = "plikd-unwrapped";
    inherit version src vendorHash postPatch;

    subPackages = [ "server" ];
    postFixup = ''
      mv $out/bin/server $out/bin/plikd
    '';
  };
}
