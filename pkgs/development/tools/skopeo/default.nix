{ stdenv
, buildGoPackage
, fetchFromGitHub
, runCommand
, gpgme
, libgpgerror
, lvm2
, btrfs-progs
, pkg-config
, libselinux
, go-md2man
, installShellFiles
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

  goPackagePath = "github.com/containers/skopeo";

  vendorPath = "${goPackagePath}/vendor/github.com/containers/image/v5";

in
buildGoPackage {
  pname = "skopeo";
  inherit version;
  inherit src goPackagePath;

  outputs = [ "bin" "man" "out" ];

  excludedPackages = [ "integration" ];

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles ];
  buildInputs = [ gpgme ]
  ++ stdenv.lib.optionals stdenv.isLinux [ libgpgerror lvm2 btrfs-progs libselinux ];

  buildFlagsArray = ''
    -ldflags=
    -X ${vendorPath}/signature.systemDefaultPolicyPath=${defaultPolicyFile}
    -X ${vendorPath}/internal/tmpdir.unixTempDirForBigFiles=/tmp
  '';

  postBuild = ''
    # depends on buildGoPackage not changing …
    pushd ./go/src/${goPackagePath}
    make install-docs MANINSTALLDIR="$man/share/man"
    installShellCompletion --bash completions/bash/skopeo
    popd
  '';

  meta = with stdenv.lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
