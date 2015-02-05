{ lib, goPackages, pkgconfig, libmtp, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "9c2b46050e8ea8574eaec2124867ac7b11e6471d";
  name = "go-mtpfs-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/hanwen/go-mtpfs";
  src = fetchFromGitHub {
    inherit rev;
    owner = "hanwen";
    repo = "go-mtpfs";
    sha256 = "0kxi18cb078q4wikfajp3yvp802wzfsfdp431j0dg2jdw8y7gfii";
  };

  buildInputs = [ go-fuse libmtp usb ];

  subPackages = [ "./" ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "A simple FUSE filesystem for mounting Android devices as a MTP device";
    homepage    = https://github.com/hanwen/go-mtpfs;
    maintainers = with maintainers; [ bennofs ];
    platforms   = platforms.linux;
    license     = licenses.bsd3;
  };
}
