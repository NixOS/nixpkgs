{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lnch";
  version = "unstable-2021-08-15";

  src = fetchFromGitHub {
    owner = "oem";
    repo = pname;
    rev = "56b5e256b46c002821bef3b9c1b6f68b9dbb4207";
    sha256 = "sha256-Iro/FjPFMqulcK90MbludnOXkMEHW0QSCoQRL01/LDE";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/oem/lnch";
    description = "Launches a process and moves it out of the process group";
    license = licenses.mit;
  };
}
