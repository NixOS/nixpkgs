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
, dockerTools
, runCommand
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.10.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "sha256-Q6gdkaIYTDUqDbjmE9TcRtQcHjpOJ3bXLJtN8NPp9KA=";
  };

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/skopeo completions docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out make install-binary install-completions
    PREFIX=$man make install-docs
    install ${passthru.policy}/default-policy.json -Dt $out/etc/containers
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  '' + ''
    runHook postInstall
  '';

  passthru = {
    policy = runCommand "policy" { } ''
      install ${src}/default-policy.json -Dt $out
    '';
    tests = {
      inherit (dockerTools.examples) testNixFromDockerHub;
    };
  };

  meta = with lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
