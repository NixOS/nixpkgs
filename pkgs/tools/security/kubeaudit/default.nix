{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fdvlVORRREEwhBrOEAnspLJw7OPj3xymJEoJMdhN5n8=";
  };

  vendorSha256 = "sha256-DVXevOOQQjMhZ+9HLlQpKA1mD4FkIkGtq+Ur8uKTcwU=";

  postInstall = ''
    mv $out/bin/cmd $out/bin/$pname
  '';

  # Tests require a running Kubernetes instance
  doCheck = false;

  meta = with lib; {
    description = "Audit tool for Kubernetes";
    homepage = "https://github.com/Shopify/kubeaudit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
