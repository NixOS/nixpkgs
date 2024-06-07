{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, getent
, nix-update-script
, testers
, prometheus-php-fpm-exporter
}:

buildGoModule rec {
  pname = "php-fpm_exporter";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "hipages";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ggrFnyEdGBoZVh4dHMw+7RUm8nJ1hJXo/fownO3wvzE=";
  };

  vendorHash = "sha256-OK36tHkBtosdfEWFPYMtlbzCkh5cF35NBWYyJrb9fwg=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  ldflags = [
    "-X main.version=${version}"
  ];

  preFixup = ''
    wrapProgram "$out/bin/php-fpm_exporter" \
      --prefix PATH ":" "${lib.makeBinPath [ getent ]}"
  '';

  postInstall = ''
    installShellCompletion --cmd php-fpm_exporter \
      --bash <($out/bin/php-fpm_exporter completion bash) \
      --fish <($out/bin/php-fpm_exporter completion fish) \
      --zsh <($out/bin/php-fpm_exporter completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion {
      inherit version;
      package = prometheus-php-fpm-exporter;
      command = "php-fpm_exporter version";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/hipages/php-fpm_exporter";
    description = "A prometheus exporter for PHP-FPM";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "php-fpm_exporter";
  };
}
