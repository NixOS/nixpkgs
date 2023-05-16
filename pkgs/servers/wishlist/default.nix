{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wishlist";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "wishlist";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NOR7YCLcwjf+oAi46qL6NteKLMSvJpqu9UzO6UvgcVQ=";
  };

  vendorHash = "sha256-v8R0e52CpyLKiuYcEZFWAY64tgCBZE2dY0vgqsHWeAc=";
=======
    sha256 = "sha256-O2ciXaWH2QSoqDTnDxmqwgK/BM5WHye8JHfw9+zZxZ4=";
  };

  vendorHash = "sha256-wZugmCP3IouZ9pw3NEAZcoqdABMGTVi/IcithQjVFW4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A single entrypoint for multiple SSH endpoints";
    homepage = "https://github.com/charmbracelet/wishlist";
    changelog = "https://github.com/charmbracelet/wishlist/releases/tag/v${version}";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ caarlos0 penguwin ];
=======
    maintainers = with maintainers; [ penguwin ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
