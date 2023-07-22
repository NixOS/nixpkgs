{ lib, buildGoModule, fetchFromGitHub, testers, mcumgr }:

buildGoModule rec {
  pname = "mcumgr";
  version = "unstable-2022-10-04";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-mcumgr-cli";
    rev = "5c56bd24066c780aad5836429bfa2ecc4f9a944c";
    hash = "sha256-WyaDnCRyZRwOkZyzNp1ouhNY5HuAvU6U3yUjiB5m+uE=";
  };

  vendorHash = "sha256-EPwV47zeBqxQPtD9QeQTKB64PmMt4HYseg38cI/owwE=";

  postPatch = ''
    substituteInPlace mcumgr/mcumgr.go \
      --replace 'VersionString: "0.0.0-dev"' 'VersionString: "${version}"'
  '';

  passthru.tests.version = testers.testVersion {
    package = mcumgr;
    command = "mcumgr version";
    inherit version;
  };

  meta = {
    description = "Tool to communicate with and manage remote devices running an mcumgr server";
    homepage = "https://github.com/apache/mynewt-mcumgr-cli/";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pkharvey ];
  };
}
