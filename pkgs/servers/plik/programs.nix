{ lib, buildGoModule, fetchFromGitHub, fetchurl, makeWrapper, runCommand }:

let
<<<<<<< HEAD
  version = "1.3.7";
=======
  version = "1.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Agkwo1oat1LDP6EJBVOoq+d+p80BGOLS4K7WTue5Nbg=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-Xfk7+60iB5/qJh/6j6AxW0aKXuzdINRfILXRzOFejW4=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    inherit version meta src vendorHash postPatch;
=======
    inherit version meta src vendorSha256 postPatch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    subPackages = [ "client" ];
    postInstall = ''
      mv $out/bin/client $out/bin/plik
    '';
  };

  plikd-unwrapped = buildGoModule {
    pname = "plikd-unwrapped";
<<<<<<< HEAD
    inherit version src vendorHash postPatch;
=======
    inherit version src vendorSha256 postPatch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    subPackages = [ "server" ];
    postFixup = ''
      mv $out/bin/server $out/bin/plikd
    '';
  };
}
