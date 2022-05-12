{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "161z88nx2x2j4q8fbxryv7v63f9aw7wpvl6vg6x4xzllnrw6p607";
  };

  cargoSha256 = "0ma3kaaa4bl11015gxijwzyxhixz947k8byaypmmw0dj9m1vhv77";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE =
    if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [ libcap_ng libseccomp ];

  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 /* and */ bsd3 ];
  };
}
