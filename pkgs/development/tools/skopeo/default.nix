{ stdenv
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
  version = "1.2.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "1v7k3ki10i6082r7zswblyirx6zck674y6bw3plssw4p1l2611rd";
  };

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ stdenv.lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    patchShebangs .
    make bin/skopeo docs
  '';

  installPhase = ''
    install -Dm755 bin/skopeo -t $out/bin
    installManPage docs/*.[1-9]
    installShellCompletion --bash completions/bash/skopeo
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${stdenv.lib.makeBinPath [ fuse-overlayfs ]}
  '';

  meta = with stdenv.lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
