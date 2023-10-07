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
, fetchpatch
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

  vendorHash = "sha256-yRMsf8KfpNmVUX4Rn4ZPLUPFZCT/g78MKAfgbFDPVkE=";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "distrobuilder";
    rev = "distrobuilder-${version}";
    sha256 = "sha256-t3ECLtb0tvIzTWgjmVQDFza+kcm3abTZZMSGYjvw1qQ=";
    fetchSubmodules = false;
  };

  buildInputs = bins;

  patches = [
    # go.mod update: needed to to include a newer lxd which contains
    # https://github.com/canonical/lxd/commit/d83f061a21f509d42b7a334b97403d2a019a7b52
    # which is needed to fix the build w/glibc-2.36.
    (fetchpatch {
      url = "https://github.com/lxc/distrobuilder/commit/5346bcc77dd7f141a36a8da851f016d0b929835e.patch";
      sha256 = "sha256-H6cSbY0v/FThx72AvoAvUCs2VCYN/PQ0W4H82mQQ3SI=";
    })
    # Fixup to keep it building after go.mod update.
    (fetchpatch {
      url = "https://github.com/lxc/distrobuilder/commit/2c8cbfbf603e7446efce9f30812812336ccf4f2c.patch";
      sha256 = "sha256-qqofghcHGosR2qycGb02c8rwErFyRRhsRKdQfyah8Ds=";
    })
  ];

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
