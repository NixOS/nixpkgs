{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "juicity";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "juicity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-k6rx55AxdUWEdnqsTj0Xq9gafx0TCdziNcf61nz//Z8=";
  };

  vendorHash = "sha256-cUbN5/MHawzzQZgrdnt28yRtPClTdIUJZm1GjcWf0dI=";

  proxyVendor = true;

  ldflags = [
    "-X=github.com/juicity/juicity/config.Version=${version}"
  ];

  subPackages = [
    "cmd/server"
    "cmd/client"
  ];

  postInstall = ''
    mv $out/bin/client $out/bin/juicity-client
    mv $out/bin/server $out/bin/juicity-server
    install -Dm444 install/juicity-server.service $out/lib/systemd/system/juicity-server.service
    install -Dm444 install/juicity-client.service $out/lib/systemd/system/juicity-client.service
    substituteInPlace $out/lib/systemd/system/juicity-server.service \
      --replace /usr/bin/juicity-server $out/bin/juicity-server
    substituteInPlace $out/lib/systemd/system/juicity-client.service \
      --replace /usr/bin/juicity-client $out/bin/juicity-client
  '';

  meta = with lib; {
    homepage = "https://github.com/juicity/juicity";
    description = "A quic-based proxy protocol";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ oluceps ];
  };
}
