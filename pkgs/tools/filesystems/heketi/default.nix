{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "heketi";
  version = "10.4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9XwML6j8Yd48CaPGcnNfTomVSovmsEUEBgc3StUasJ0=";
  };

  vendorHash = "sha256-TR01Al+/AhAp7tMgnaLQ22ksONbj2+c5GQ1Zp1ikVIU=";

  ldflags = [ "-s" "-w" "-X main.HEKETI_VERSION=${version}" "-X main.HEKETI_CLI_VERSION=${version}" ];

  doCheck = false;

  postInstall = ''
    mv -v $out/bin/go $out/bin/heketi-cli
  '';

  meta = with lib; {
    description = "RESTful-based volume management framework for GlusterFS";
    homepage = "https://github.com/heketi/heketi";
    license = with licenses; [ asl20 lgpl3Plus gpl2 ];
    maintainers = with maintainers; [ arikgrahl ];
  };
}
