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
, testers
, skopeo
}:

buildGoModule rec {
  pname = "skopeo";
<<<<<<< HEAD
  version = "1.13.3";
=======
  version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
<<<<<<< HEAD
    hash = "sha256-FTPBeq/WbrYDEmS1fR8rzDBHBsjdyMHcm+tCxXtYUPg=";
=======
    hash = "sha256-a4uM2WjDhjz4zTiM2HWoDHQQ9aT38HV9GNUJAJmZR+w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "man" ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
<<<<<<< HEAD
    ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];
=======
  ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/skopeo completions docs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=${placeholder "out"} make install-binary install-completions install-docs
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
      version = testers.testVersion {
        package = skopeo;
      };
      inherit (dockerTools.examples) testNixFromDockerHub;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/containers/skopeo/releases/tag/${src.rev}";
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo developer-guy ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
