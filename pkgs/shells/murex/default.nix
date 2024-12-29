{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "6.2.3000";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y9FVmIYipEkKXHU7TcRX7s/8/50b5fYnPLalFXHPomM=";
  };

  vendorHash = "sha256-/qK7Zgdz48vmz+tIMZmo1M5Glr842fOCinMoLAeQasg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    mainProgram = "murex";
    homepage = "https://murex.rocks";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
