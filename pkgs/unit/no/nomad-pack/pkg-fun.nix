{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "0.0.1-techpreview.3";
  rev   = "3b4163b3b826c8408ae824238daaa45307d03380";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "sha256-Br+BJRAo9qSJQjg2awQTnsYz76WReVWsTUw6XoUb1YY=";
  };

  vendorSha256 = "sha256-dUPDwKdkBXBfyfbFxrpgHwZ0Q5jB7aamClNmv+tLCGA=";

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };

}
