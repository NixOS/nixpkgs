{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "adreaper";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "AidenPearce369";
    repo = "ADReaper";
    rev = "ADReaperv${version}";
    sha256 = "sha256-+FCb5TV9MUcRyex2M4rn2RhcIsXQFbtm1T4r7MpcRQs=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-lU39kj/uz0l7Rodsu6+UMv2o579eu1KUbutUNZni7bM=";
=======
  vendorSha256 = "sha256-lU39kj/uz0l7Rodsu6+UMv2o579eu1KUbutUNZni7bM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/ADReaper $out/bin/$pname
  '';

  meta = with lib; {
    description = "Enumeration tool for Windows Active Directories";
    homepage = "https://github.com/AidenPearce369/ADReaper";
    # Upstream doesn't have a license yet
    # https://github.com/AidenPearce369/ADReaper/issues/2
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "ADReaper";
  };
}
