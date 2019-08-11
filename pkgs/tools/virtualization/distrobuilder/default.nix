{ stdenv, pkgconfig, buildGoPackage, fetchFromGitHub
, makeWrapper, coreutils, gnupg, gnutar, squashfsTools, debootstrap
}:

let binPath = stdenv.lib.makeBinPath [
  coreutils gnupg gnutar squashfsTools debootstrap
];
in
buildGoPackage rec {
  name = "distrobuilder-${version}";
  version = "2019_10_07";
  rev = "d686c88c21838f5505c3ec14711b2413604d7f5c";

  goPackagePath = "github.com/lxc/distrobuilder";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "distrobuilder";
    sha256 = "0k59czgasy4d58bkrin6hvgmh7y3nf177lwd0y4g47af27bgnyc4";
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

