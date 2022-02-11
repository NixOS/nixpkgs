{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "updatecli";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "updatecli";
    repo = "updatecli";
    rev = "v${version}";
    sha256 = "sha256-NdjGwrR4ZNdT/h0TPf/PZL12SJhWHvfzDNd1pyh+dtM=";
  };

  vendorSha256 = "sha256-e2HHoH6uSPmuELimXwlvDBwffj1mzAIj1kJ/27QNgXc=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/updatecli completion $shell > updatecli.$shell
      installShellCompletion updatecli.$shell
    done
  '';

  meta = with lib; {
    description =
      "Automatically open a PR on your GitOps repository when a third party service publishes an update";
    homepage = "https://updatecli.io/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.koozz ];
    mainProgram = "updatecli";
  };
}
