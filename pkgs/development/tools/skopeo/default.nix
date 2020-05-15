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
}:

let
  version = "0.2.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "09zqzrw6f1s6kaknnj3hra3xz4nq6y86vmw5vk8p4f6g7cwakg1x";
  };

  defaultPolicyFile = runCommand "skopeo-default-policy.json" {} "cp ${src}/default-policy.json $out";

  vendorPath = "github.com/containers/skopeo/vendor/github.com/containers/image/v5";

in
buildGoModule {
  pname = "skopeo";
  inherit version;
  inherit src;

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  excludedPackages = [ "integration" ];

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ stdenv.lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildFlagsArray = ''
    -ldflags=
    -X ${vendorPath}/signature.systemDefaultPolicyPath=${defaultPolicyFile}
    -X ${vendorPath}/internal/tmpdir.unixTempDirForBigFiles=/tmp
  '';

  postBuild = ''
    make install-docs MANINSTALLDIR="$man/share/man"
    installShellCompletion --bash completions/bash/skopeo
  '';

  postInstall = stdenv.lib.optionals stdenv.isLinux ''
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
