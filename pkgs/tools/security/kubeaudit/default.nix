{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-exJGjFeqk3hM52Zgfs+2JEVdzVZf79ZRQH2krusiw8c=";
  };

  vendorSha256 = "sha256-hi83C05eEXqQ6kMGv6n/fjsYAXveyVRqKZds5iv8Oio=";

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
