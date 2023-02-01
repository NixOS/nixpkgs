{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
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
  version = "1.11.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    hash = "sha256-P556Is03BeC0Tf+kNv+Luy0KASgTXsyZ/MrPaPFUHE8=";
  };

  patches = [
    # revert version to 1.11.0 (remove in next release)
    (fetchpatch {
      url = "https://github.com/containers/skopeo/commit/cc958d3e5d47cb71f60f8882f10ef041605e1a32.patch";
      revert = true;
      hash = "sha256-ZmwbJnfYTDl9LYU0Y3COeOs7d5OVigTpct57CkNU6Gg=";
    })
  ];

  outputs = [ "out" "man" ];

  vendorHash = null;

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
