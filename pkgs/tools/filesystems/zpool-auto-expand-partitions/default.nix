{ rustPlatform
, cloud-utils
, fetchFromGitHub
, lib
, llvmPackages
, pkg-config
, util-linux
, zfs
}:
rustPlatform.buildRustPackage rec {
  pname = "zpool-auto-expand-partitions";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "zpool-auto-expand-partitions";
    rev = "v${version}";
    hash = "sha256-LA6YO6vv7VCXwFfayQVxVR80niSCo89sG0hqh0wDEh8=";
  };

  cargoHash = "sha256-5v0fqp8aro+QD/f5VudMREc8RvKQapNAoArcCKMN1Sw=";

  preBuild = ''
    substituteInPlace src/grow.rs \
      --replace '"growpart"' '"${cloud-utils}/bin/growpart"'
    substituteInPlace src/lsblk.rs \
      --replace '"lsblk"' '"${util-linux}/bin/lsblk"'
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    util-linux
    zfs
  ];

  meta = with lib; {
    description = "A tool that aims to expand all partitions in a specified zpool to fill the available space";
    homepage = "https://github.com/DeterminateSystems/zpool-auto-expand-partitions";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
