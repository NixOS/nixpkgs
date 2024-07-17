{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:

buildGoModule rec {
  pname = "devd";
  version = "unstable-2020-04-27";

  src = fetchFromGitHub {
    owner = "cortesi";
    repo = "devd";
    rev = "c1a3bfba27d8e028de90fb24452374412a4cffb3";
    hash = "sha256-k0zj7fiYbaHnNUUI7ruD0vXiT4c1bxPuR4I0dRouCbU=";
  };

  vendorHash = "sha256-o7MbN/6n7fkp/yqYyQbfWBUqI09/JYh5jtV31gjNf6w=";

  patches = [
    # Update x/sys to support go 1.17.
    (fetchpatch {
      url = "https://github.com/cortesi/devd/commit/5f4720bf41399736b4e7e1a493da6c87a583d0b2.patch";
      hash = "sha256-WDN08XNsDPuZwBCE8iDXgGAWFwx2UTwqRkhzKMtPKR8=";
    })
  ];

  subPackages = [ "cmd/devd" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A local webserver for developers";
    mainProgram = "devd";
    homepage = "https://github.com/cortesi/devd";
    license = licenses.mit;
    maintainers = with maintainers; [ brianhicks ];
  };
}
