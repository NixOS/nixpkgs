{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "onmetal-image";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "unstable-2022-09-28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "onmetal";
    repo = "onmetal-image";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-KvOBvAIE9V2bj5prdcc8G5ifHsvybHBCYWrI4fWtdvE=";
  };

  vendorHash = "sha256-aCL8hLcBnIs5BJM7opIwcOLvOS3uL9mYXs1vOAMlX/M=";
=======
    rev = "26f6ac2607e1cac19c35fac94aa8cd963b19628a";
    sha256 = "sha256-ITUm7CEaz8X7LhArGJXk4YKQcX+kOvju6Go+fGfFOcw=";
  };

  vendorSha256 = "sha256-ISDNqXoJEYy6kfCZGqHoie0jMOw9bgjYGHqBGx6mymc=";

  subPackages = [ "cmd" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/onmetal-image

<<<<<<< HEAD
    installShellCompletion --cmd onmetal-image \
      --bash <($out/bin/onmetal-image completion bash) \
      --fish <($out/bin/onmetal-image completion fish) \
      --zsh <($out/bin/onmetal-image completion zsh)
=======
   installShellCompletion --cmd onmetal-image \
     --bash <($out/bin/onmetal-image completion bash) \
     --fish <($out/bin/onmetal-image completion fish) \
     --zsh <($out/bin/onmetal-image completion zsh)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Onmetal OCI Image Specification, Library and Tooling";
    homepage = "https://github.com/onmetal/onmetal-image";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
