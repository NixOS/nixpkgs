{ lib, buildGoModule, fetchFromGitHub, pkg-config, libusb1 }:

buildGoModule rec {
  pname = "wally-cli";
  version = "2.0.0";

  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally-cli";
    rev = "${version}-linux";
    sha256 = "0xz3z18bbnf736ngjj6jhnp3p2j55m5jhnb2xl6l5hybracfyhm7";
  };

  vendorSha256 = "0jqx38x5qvir6zc5yq9p2adafwqhy4hil1k5g81rr1fvbn06k3a6";
  runVend = true;

  # Can be removed when https://github.com/zsa/wally-cli/pull/1 is merged.
  doCheck = false;

  meta = with lib; {
    description = "A tool to flash firmware to mechanical keyboards";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ spacekookie r-burns ];
  };
}
