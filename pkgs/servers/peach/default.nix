{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "peach";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "peachdocs";
    repo = "peach";
    rev = "v${version}";
    sha256 = "1pzk3sah39hz8n1kswxl35djh6wm0qcfcwrbfi50nd4k3bdgz7xl";
  };

  vendorSha256 = "0f215hd5a9d4fyvdirp2j14ghap5vwv12i28jmzm6wxjihj8nn1g";

  meta = with lib; {
    description = "Web server for multi-language, real-time synchronization and searchable documentation";
    homepage = "https://peachdocs.org/";
    license = licenses.asl20;
    maintainers = [ maintainers.ivar ];
  };
}
