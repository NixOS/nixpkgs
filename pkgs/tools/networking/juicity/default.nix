{ lib
, fetchFromGitHub
, buildGo121Module
}:
buildGo121Module rec {
  pname = "juicity";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "juicity";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+P7MFNhWI4aqCtcJhAw3/RtfOkh+b3v2v69pIOznc/8=";
  };

  vendorHash = "sha256-KrkEqvgHyAoNAX93SE9yDuik60CvPeP+w0Xehi7lgi0=";

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
