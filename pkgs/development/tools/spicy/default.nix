{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "spicy";
  version = "unstable-2020-02-21";

  goPackagePath = "github.com/trhodeos/spicy";

  src = fetchFromGitHub {
    owner = "trhodeos";
    repo = "spicy";
    rev = "47409fb73e0b20b323c46cc06a3858d0a252a817";
    sha256 = "022r8klmr21vaz5qd72ndrzj7pyqpfxc3jljz7nzsa50fjf82c3a";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A Nintendo 64 segment assembler";
    longDescription = ''
      An open-source version of the Nintendo64 sdk's mild.exe. Assembles
      segments into an n64-compatible rom.
    '';
    homepage = "https://github.com/trhodeos/spicy";
    license = licenses.mit;
    maintainers = [ maintainers._414owen];
  };
}
