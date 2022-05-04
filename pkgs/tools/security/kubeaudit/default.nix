{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "sha256-aMnhEY16SybE5Oavc6stw7xoyNblCwFJpzYHsDBENX4=";
  };

  vendorSha256 = "sha256-plsnzeRIaJNNzrkzQYtxOqWejTDntPRemIhcfpxXgBg=";

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
