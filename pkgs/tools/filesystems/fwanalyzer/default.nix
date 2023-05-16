{ lib
, buildGoModule
, fetchFromGitHub
, e2tools
, makeWrapper
, mtools
}:

buildGoModule rec {
  pname = "fwanalyzer";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "cruise-automation";
    repo = pname;
    rev = version;
    sha256 = "sha256-fcqtyfpxdjD+1GsYl05RSJaFDoLSYQDdWcQV6a+vNGA=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-nLr12VQogr4nV9E/DJu2XTcgEi7GsOdOn/ZqVk7HS7I=";
=======
  vendorSha256 = "sha256-nLr12VQogr4nV9E/DJu2XTcgEi7GsOdOn/ZqVk7HS7I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/${pname}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/fwanalyzer" --prefix PATH : "${lib.makeBinPath [ e2tools mtools ]}"
  '';

  # The tests requires an additional setup (unpacking images, etc.)
  doCheck = false;

  meta = with lib; {
    description = "Tool to analyze filesystem images";
    homepage = "https://github.com/cruise-automation/fwanalyzer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
