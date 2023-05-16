{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
<<<<<<< HEAD
  version = "1.15.2";
=======
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-WzyTLOJo/wTZA9glxO0ovcaADlHV+AKLChWSLJ+uvaQ=";
  };

  vendorHash = "sha256-KIMnvGMIipuIFPTSeERtCfvlPuvHvEHdjBJ1TbT2d1s=";
=======
    sha256 = "sha256-Uwi21dNhpDhrcLS2Ra0vaRsvdqEz7FX7SPILeq12ZnE=";
  };

  vendorHash = "sha256-BGm3LvKOtlba/BtZ4Ue3Tzphlj5ZSqSzXTF8gSgRYEU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
