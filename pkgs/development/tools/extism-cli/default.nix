{
  lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-t53VJOc1umIwPyS6hkAm+u9KsKiYas4iRrlraofJSEY=";
  };

  modRoot = "./extism";

  vendorHash = "sha256-Ukbg2CG2qeLmM9HijKXZY/fEY2QfJXTyaTIsEDT5W6E=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # Tests require network access

  postInstall = ''
    local INSTALL="$out/bin/extism"
    installShellCompletion --cmd extism \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  meta = with lib; {
    description = "The extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
