{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "kube-prompt";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "c-bata";
    repo = "kube-prompt";
    rev = "v${version}";
    sha256 = "sha256-9OWsITbC7YO51QzsRwDWvojU54DiuGJhkSGwmesEj9w=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-WS63Eub5v8JACXTAh+ca/BYzq/Moc+y8ej4lKNFctjQ=";

  meta = with lib; {
    description = "An interactive kubernetes client featuring auto-complete";
    license = licenses.mit;
    homepage = "https://github.com/c-bata/kube-prompt";
    maintainers = with maintainers; [ vdemeester ];
  };
}
