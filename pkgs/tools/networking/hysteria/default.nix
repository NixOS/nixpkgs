{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gNAK+WOowBlEzUYX25cQxywerNlMIx7cqG1wV9iLS5s=";
  };

  vendorHash = "sha256-Ixfwqrg+4/dzJLj3q7NbgpUXFj4qGKT0QVFQV/X4pqw=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}
