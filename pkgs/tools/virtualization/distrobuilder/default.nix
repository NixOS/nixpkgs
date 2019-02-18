{ stdenv, pkgconfig, buildGoPackage, fetchFromGitHub
, makeWrapper, coreutils, gnupg, gnutar, squashfsTools, debootstrap
}:

let binPath = stdenv.lib.makeBinPath [
  coreutils gnupg gnutar squashfsTools debootstrap
];
in
buildGoPackage rec {
  name = "distrobuilder-${version}";
  version = "2018_10_04";
  rev = "d2329be9569d45028a38836186d2353b8ddfe1ca";

  goPackagePath = "github.com/lxc/distrobuilder";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "distrobuilder";
    sha256 = "1sn1wif86p089kr6zq83k81hjd1d73kamnawc2p0k0vd0w91d3v4";
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

