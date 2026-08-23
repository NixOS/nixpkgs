{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "kubectl-aliases";
  version = "unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-aliases";
    rev = "7549fa45bbde7499b927c74cae13bfb9169c9497";
    hash = "sha256-NkprSk55aRVHiq9JXduQl6AGZv5pBLHznRToOdm9OUw=";
  };

  postInstall = ''
    mkdir -p $out/share/fish/vendor_conf.d/
    cp .kubectl_aliases.fish $out/share/fish/vendor_conf.d/
  '';

  meta = {
    description = "Programmatically generated handy kubectl aliases.";
    homepage = "https://github.com/ahmetb/kubectl-aliases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mattfield ];
  };
}
