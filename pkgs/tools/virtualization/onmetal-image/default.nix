{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "onmetal-image";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "onmetal";
    repo = "onmetal-image";
    rev = "v${version}";
    hash = "sha256-KvOBvAIE9V2bj5prdcc8G5ifHsvybHBCYWrI4fWtdvE=";
  };

  vendorHash = "sha256-aCL8hLcBnIs5BJM7opIwcOLvOS3uL9mYXs1vOAMlX/M=";

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
    maintainers = with maintainers; [ ];
    mainProgram = "onmetal-image";
  };
}
