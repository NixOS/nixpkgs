{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.6.1";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "/KL1LH/3txWrZPjvuYmSkNb93euB+Whd2YofIuf/cMg=";
  };

  cargoHash = "sha256-EkDop9v75IIIWEK+QI5v58lO20RxgJab/scFmn26idU=";

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
