{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubeaudit";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "sha256-AIvH9HF0Ha1b+NZiJmiT6beYuKnCqJMXKzDFUzV9J4c=";
  };

  vendorSha256 = "sha256-XrEzkhQU/KPElQNgCX6yWDMQXZSd3lRXmUDJpsj5ACY=";

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
