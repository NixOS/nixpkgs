{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "netdata-go-plugins";
<<<<<<< HEAD
  version = "0.54.1";
=======
  version = "0.52.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3cBgXkvXhSTwQ6qbUbH1nOba5QkjSKtzi2rb+OY06jE=";
  };

  vendorHash = "sha256-DLRcS8wqnwGRLEeMqWj5SfUvE3fz1hty9jItNfmCdRw=";
=======
    hash = "sha256-/oDUB6EGRq26cRdHwkuTgCRZ+XtNy238TnOYMX1H22s=";
  };

  vendorHash = "sha256-hxsLCiti/IiTjYPKm/9fWk3CNzDM1+gRgncFXgB/whk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  passthru.tests = { inherit (nixosTests) netdata; };

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    changelog = "https://github.com/netdata/go.d.plugin/releases/tag/v${version}";
    license = licenses.gpl3Only;
<<<<<<< HEAD
    maintainers = [ maintainers.raitobezarius ];
=======
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
