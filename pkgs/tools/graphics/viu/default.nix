{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1ivhm6js0ylnxwp84jmm2vmnl4iy1cwr3m9imx7lmcl0i3c8b9if";
  };
  # tests are failing, reported at upstream: https://github.com/atanunq/viu/issues/40
  doCheck = false;

  cargoSha256 = "15zdnr95a363w4rddv1fbz796m01430gzly5p953m23g2mbxdmp0";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
