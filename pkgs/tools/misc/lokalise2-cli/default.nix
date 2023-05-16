{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "2.6.8";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-U8XN7cH64ICVxcjmIWBeelOT3qQlGt6MhOPgUWkCPF0=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-PM3Jjgq6mbM6iVCXRos9UsqqFNaXOqq713GZ2R9tQww=";
=======
  vendorSha256 = "sha256-PM3Jjgq6mbM6iVCXRos9UsqqFNaXOqq713GZ2R9tQww=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    mainProgram = "lokalise2";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
