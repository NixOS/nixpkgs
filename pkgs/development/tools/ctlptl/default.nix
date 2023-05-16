{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ctlptl";
<<<<<<< HEAD
  version = "0.8.22";
=======
  version = "0.8.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/LKsaWqJZG9LdUt9zVAspLOYGr0TrhOJB4j0Vv40rkE=";
  };

  vendorHash = "sha256-nfSqu1u7NWbZYL7CEZ/i2tdxQBblRbwJwdwoEtol/Us=";
=======
    hash = "sha256-J1mq25EcoSvZNvfkBWQjRG0eXWFroNqQ8ylEohoninI=";
  };

  vendorHash = "sha256-QGceY4xUdjPyO0XGpE0mvP5Q5nQKc/tkBp0Iseuw8Ro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
