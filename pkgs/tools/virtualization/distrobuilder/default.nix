{ lib
, pkg-config
, buildGoModule
, fetchFromGitHub
, makeWrapper
, coreutils
, gnupg
, gnutar
, squashfsTools
, debootstrap
}:

let
  bins = [
    coreutils
    gnupg
    gnutar
    squashfsTools
    debootstrap
  ];
in
buildGoModule rec {
  pname = "distrobuilder";
  version = "1.3";

  vendorSha256 = "sha256-FKnpoLA4enZ1vGSJQFLbp/OjoEgdxagL73ucxUgIoKY=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    rev = "distrobuilder-${version}";
    sha256 = "sha256-cvxbJbg9yTcAPWQccH+1nQivwRh8CIN3Cga2HKY8VlQ=";
    fetchSubmodules = false;
  };

  buildInputs = bins;

  # tests require a local keyserver (mkg20001/nixpkgs branch distrobuilder-with-tests) but gpg is currently broken in tests
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ] ++ bins;

  postInstall = ''
    wrapProgram $out/bin/distrobuilder --prefix PATH ":" ${lib.makeBinPath bins}
  '';

  meta = with lib; {
    description = "System container image builder for LXC and LXD";
    homepage = "https://github.com/lxc/distrobuilder";
    license = licenses.asl20;
    maintainers = with maintainers; [ megheaiulian ];
    platforms = platforms.linux;
  };
}
