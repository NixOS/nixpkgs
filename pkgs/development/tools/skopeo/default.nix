{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, gpgme
, lvm2
, btrfs-progs
, pkg-config
, go-md2man
, installShellFiles
, makeWrapper
, fuse-overlayfs
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "sha256-7FHfqDgc91BdtbvcElZDWj2jXD2LcMPo9RLnYZe3Xw8=";
  };

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    patchShebangs .
    make bin/skopeo docs
  '';

  installPhase = ''
    install -Dm755 bin/skopeo -t $out/bin
    installManPage docs/*.[1-9]
    installShellCompletion --bash completions/bash/skopeo
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  '';

  meta = with lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
