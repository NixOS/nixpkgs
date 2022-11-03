{ lib, buildGoModule, fetchFromGitHub, pkg-config, libusb1, updateGolangSysHook }:

buildGoModule rec {
  pname = "wally-cli";
  version = "2.0.1";

  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config updateGolangSysHook ];

  buildInputs = [ libusb1 ];

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally-cli";
    rev = "${version}-linux";
    sha256 = "NuyQHEygy4LNqLtrpdwfCR+fNy3ZUxOClVdRen6AXMc=";
  };

  vendorSha256 = "sha256-FLF3myDaGkfzMviEiHGmVoFexbXSH3PpX4R7kIlZmNI=";

  meta = with lib; {
    description = "A tool to flash firmware to mechanical keyboards";
    homepage = "https://ergodox-ez.com/pages/wally-planck";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ spacekookie r-burns ];
  };
}
