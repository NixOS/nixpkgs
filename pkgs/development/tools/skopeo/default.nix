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
  version = "1.14.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    hash = "sha256-6PSxYM6u727vHf4FP0ju0TAuqj4R4bxQEdyZHvC4qBA=";
  };

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
