{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "azure-vhd-utils";
  version = "unstable-2016-06-14";

  goPackagePath = "github.com/Microsoft/azure-vhd-utils";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "azure-vhd-utils";
    rev = "070db2d701a462ca2edcf89d677ed3cac309d8e8";
    sha256 = "sha256-8EH7RpuAeYKd5z64mklKKlFi20KYcx2WhVmkRbdaMy0=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/Microsoft/azure-vhd-utils";
    description = "Read, inspect and upload VHD files for Azure";
    longDescription = "Go package to read Virtual Hard Disk (VHD) file, a CLI interface to upload local VHD to Azure storage and to inspect a local VHD";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

