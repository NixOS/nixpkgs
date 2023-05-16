{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
<<<<<<< HEAD
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "e11762a196e4fcdbde728ef160bc3c6cfeb5bc6e";
    hash = "sha256-9Fo/qKcoZg8OYH4cok18rweA1PAFULOCJGTdUB8fbAU=";
  };

  vendorHash = "sha256-7un8oi6pKYiJGw6mbG35crndLg35y7VkoAnQKMJduh4=";
=======
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xmc6xkOepvLDHcIHaYyJIO2e3yIWQxPEacS7Wx09eAM=";
  };

  vendorSha256 = "sha256-hpV+16yU03fT8FIfxbEnIcafn6H/IMpMns9onPPPrDk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  postInstall = ''
<<<<<<< HEAD
    mv $out/bin/app $out/bin/hysteria
=======
    mv $out/bin/cmd $out/bin/hysteria
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
<<<<<<< HEAD
    homepage = "https://github.com/apernet/hysteria";
=======
    homepage = "https://github.com/HyNetwork/hysteria";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}
