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
  version = "2.1";

  vendorSha256 = "sha256-6LsJ6nZIo+aC8kvF+1aZD1WoXNTj9siB8QhKPVA6MSc=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    rev = "distrobuilder-${version}";
    sha256 = "sha256-t3ECLtb0tvIzTWgjmVQDFza+kcm3abTZZMSGYjvw1qQ=";
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
