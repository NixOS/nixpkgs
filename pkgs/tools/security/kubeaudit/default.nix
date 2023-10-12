{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-e6No8Md/KZUFNtPJOrSdv1GlGmxX7+tmWNjQGFdtJpc=";
  };

  vendorHash = "sha256-IxrAJaltg7vo3SQRC7OokSD5SM8xiX7iG8ZxKYEe9/E=";

  postInstall = ''
    mv $out/bin/cmd $out/bin/$pname
  '';

  # Tests require a running Kubernetes instance
  doCheck = false;

  meta = with lib; {
    description = "Audit tool for Kubernetes";
    homepage = "https://github.com/Shopify/kubeaudit";
    changelog = "https://github.com/Shopify/kubeaudit/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
