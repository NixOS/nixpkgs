{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-validate";
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-sztpUzrVvYT3GFVbfd91rOudj/PEHHizTOzTrH1fQts=";
  };

  vendorHash = "sha256-UPmeb36kF+z37+RcyXaOsJvAto1xrJUyJqcPyODAQrY=";
=======
    sha256 = "sha256-tYdWXioiPF1S5lpAipm3UN9NUjXo1/8nx22q28UQFDY=";
  };

  vendorHash = "sha256-OOjVlRHaOLIJVg3r97qZ3lPv8ANYY2HSn7hUJhg3Cfs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
