{ lib, fetchFromGitLab, rustPlatform, udev, pkg-config }:
let

  gitsrc = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "firmware";
    repo = "librem-ec";
    rev = "05d9990d7500e1cf3d09844407f77cb64c049a12";
    sha256 = "145x8v5zmc9vp9hci0hf3lczyi1bf8hj4bawyy5vgy8bpvdsjgk7";
  };

in
rustPlatform.buildRustPackage rec {
  pname = "purism-ectool";
  version = "0.3.5";

  src = gitsrc + /tool;

  cargoSha256 = "16ahi0qpwfk7vc2wymishg19rbyadv4sk1hp0qzsjj0m3s9ws3yh";

  buildInputs = [ udev ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "The Purism EC tool";
    homepage = "https://source.puri.sm/firmware/librem-ec";
    license = licenses.gpl3;
    maintainers = [maintainers.avieth];
  };
}
