{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, installShellFiles
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "threatest";
<<<<<<< HEAD
  version = "1.2.4";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-pCSSAEeVxi3/yK7B2g9ZZRU5TjdNd8qp+52Yc1HmxT8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-nHA+UJP6gYWdbTKFcxw1gI6X2ueTUIsHVBIlaprPwsQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd threatest \
      --bash <($out/bin/threatest completion bash) \
      --fish <($out/bin/threatest completion fish) \
      --zsh <($out/bin/threatest completion zsh)
  '';
=======
    hash = "sha256-9/TIiBp3w7NaECX929Tai5nqHKxb7YxYEr2hAl2ttsM=";
  };

  vendorHash = "sha256-vTzgxByZ2BC7nuq/+LJV7LR0KsUxh1EbHFe81PwqCJc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Framework for end-to-end testing threat detection rules";
    homepage = "https://github.com/DataDog/threatest";
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
