{ stdenv, lib, pkgconfig, buildGoPackage, fetchFromGitHub
, makeWrapper, coreutils, gnupg, gnutar, squashfsTools}:

buildGoPackage rec {
  name = "distrobuilder-${version}";
  version = "2018_04_28";
  rev = "406fd5fe7dec4a969ec08bdf799c8ae483d37489";

  goPackagePath = "github.com/lxc/distrobuilder";

  src = fetchFromGitHub {
    inherit rev;
    owner = "lxc";
    repo = "distrobuilder";
    sha256 = "11bd600g36pf89vza9jl7fp7cjy5h67nfvhxlnwghb3z40pq9lnc";
  };

  goDeps = ./deps.nix;

  postInstall = ''
    wrapProgram $bin/bin/distrobuilder --prefix PATH ":" ${stdenv.lib.makeBinPath [
      coreutils gnupg gnutar squashfsTools
    ]}
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

