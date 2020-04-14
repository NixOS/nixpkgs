{ stdenv
, lib
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
}:

with stdenv.lib;

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

in
buildGoPackage {
  pname = "skopeo";
  inherit version;
  inherit src goPackagePath;

  outputs = [ "bin" "man" "out" ];

  excludedPackages = "integration";

  nativeBuildInputs = [ pkg-config (lib.getBin go-md2man) ];
  buildInputs = [ gpgme ] ++ lib.optionals stdenv.isLinux [ libgpgerror lvm2 btrfs-progs libselinux ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/containers/skopeo/vendor/github.com/containers/image/v5/signature.systemDefaultPolicyPath=${defaultPolicyFile}
    -X github.com/containers/skopeo/vendor/github.com/containers/image/v5/internal/tmpdir.unixTempDirForBigFiles=/tmp
  '';

  preBuild = ''
    export CGO_CFLAGS="$CFLAGS"
    export CGO_LDFLAGS="$LDFLAGS"
  '';

  postBuild = ''
    # depends on buildGoPackage not changing …
    pushd ./go/src/${goPackagePath}
    make install-docs MANINSTALLDIR="$man/share/man"
    popd
  '';

  meta = with stdenv.lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}
