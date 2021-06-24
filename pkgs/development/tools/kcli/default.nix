{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kcli";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "cswank";
    repo = "kcli";
    rev = version;
    sha256 = "0whijr2r2j5bvfy8jgmpxsa0zvwk5kfjlpnkw4za5k35q7bjffls";
  };

  vendorSha256 = "0whqrms5mc7v14p2h1jfvkawm30xaylivijlsghrsaq468qcgg15";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A kafka command line browser";
    homepage = "https://github.com/cswank/kcli";
    license = licenses.mit;
    maintainers = with maintainers; [ cswank ];
  };
}
