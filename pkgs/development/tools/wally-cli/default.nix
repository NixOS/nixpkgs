{ lib, buildGoModule, fetchFromGitHub, pkg-config, libusb1 }:

buildGoModule rec {
  pname = "wally-cli";
  version = "2.0.1";

  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally-cli";
    rev = "${version}-linux";
    sha256 = "NuyQHEygy4LNqLtrpdwfCR+fNy3ZUxOClVdRen6AXMc=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-HffgkuKmaOjTYi+jQ6vBlC50JqqbYiikURT6TCqL7e0=";
=======
  vendorSha256 = "sha256-HffgkuKmaOjTYi+jQ6vBlC50JqqbYiikURT6TCqL7e0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to flash firmware to mechanical keyboards";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ spacekookie r-burns ];
  };
}
