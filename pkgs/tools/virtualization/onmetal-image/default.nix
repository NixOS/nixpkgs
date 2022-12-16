{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "onmetal-image";
  version = "unstable-2022-09-28";

  src = fetchFromGitHub {
    owner = "onmetal";
    repo = "onmetal-image";
    rev = "26f6ac2607e1cac19c35fac94aa8cd963b19628a";
    sha256 = "sha256-ITUm7CEaz8X7LhArGJXk4YKQcX+kOvju6Go+fGfFOcw=";
  };

  vendorSha256 = "sha256-ISDNqXoJEYy6kfCZGqHoie0jMOw9bgjYGHqBGx6mymc=";

  subPackages = [ "cmd" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/onmetal-image

   installShellCompletion --cmd onmetal-image \
     --bash <($out/bin/onmetal-image completion bash) \
     --fish <($out/bin/onmetal-image completion fish) \
     --zsh <($out/bin/onmetal-image completion zsh)
  '';

  meta = with lib; {
    description = "Onmetal OCI Image Specification, Library and Tooling";
    homepage = "https://github.com/onmetal/onmetal-image";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
