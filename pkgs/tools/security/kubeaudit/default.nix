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

<<<<<<< HEAD
  vendorHash = "sha256-IxrAJaltg7vo3SQRC7OokSD5SM8xiX7iG8ZxKYEe9/E=";
=======
  vendorSha256 = "sha256-IxrAJaltg7vo3SQRC7OokSD5SM8xiX7iG8ZxKYEe9/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
