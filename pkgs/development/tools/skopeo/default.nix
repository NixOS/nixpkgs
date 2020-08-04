{ stdenv
, buildGoModule
, fetchFromGitHub
, runCommand
, gpgme
, lvm2
, btrfs-progs
, pkg-config
, go-md2man
, installShellFiles
, makeWrapper
, fuse-overlayfs
, nixosTests
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "0wkpw8fizxjpfypflp7rs1q128dg4hadwzdvn8k41h7f8cbcb39x";
  };

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ stdenv.lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    patchShebangs .
    make binary-local
  '';

  installPhase = ''
    make install-binary PREFIX=$out
    make install-docs MANINSTALLDIR="$man/share/man"
    installShellCompletion --bash completions/bash/skopeo
  '';

  postInstall = stdenv.lib.optionals stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${stdenv.lib.makeBinPath [ fuse-overlayfs ]}
  '';

  passthru.tests.docker-tools = nixosTests.docker-tools;

  meta = with stdenv.lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
