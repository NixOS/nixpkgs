{ lib, stdenv, rustPlatform, fetchFromGitLab, fetchpatch, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.6.1";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "/KL1LH/3txWrZPjvuYmSkNb93euB+Whd2YofIuf/cMg=";
  };

  patches = [
    # fixes SIGSYS when seccomp filtering is on
    # https://gitlab.com/virtio-fs/virtiofsd/-/issues/104
    (fetchpatch {
      url = "https://gitlab.com/virtio-fs/virtiofsd/-/commit/a9141cae72e6785ca10a758c22c7a5690a1fc955.patch";
      hash = "sha256-uO8nVdNMGOkd3ThTTw23BykDP9w4I+lEx91447zxcgo=";
    })
  ];

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
