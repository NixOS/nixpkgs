{ stdenv, pkgconfig, buildGoPackage, fetchFromGitHub
, makeWrapper, coreutils, gnupg, gnutar, squashfsTools, debootstrap
}:

let binPath = stdenv.lib.makeBinPath [
  coreutils gnupg gnutar squashfsTools debootstrap
];
in
buildGoPackage rec {
  name = "distrobuilder-${version}";
  version = "2018_06_29";
  rev = "e5acd73f81ad37151f3a2088fde650cea9b6a7e6";

  goPackagePath = "github.com/lxc/distrobuilder";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "distrobuilder";
    sha256 = "19rc11s0paqga72jr8bziixihfv7dlkszmfk6xkg0349hzdg0gac";
  };

  goDeps = ./deps.nix;

  postInstall = ''
    wrapProgram $bin/bin/distrobuilder --prefix PATH ":" ${binPath}
  '';
  nativeBuildInputs = [ pkgconfig makeWrapper ];

  meta = with stdenv.lib; {
    description = "System container image builder for LXC and LXD";
    homepage = "https://github.com/lxc/distrobuilder";
    license = licenses.asl20;
    maintainers = with maintainers; [ megheaiulian ];
    platforms = platforms.linux;
  };
}

