{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.8.0";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "sha256-tbM2JWoub789s3YanT/lqCKl6JkY+FahSYb+lHvF7W8=";
  };

  cargoHash = "sha256-l2rWR9HAXTuNEarj2hWaZxpTdUNGoCnNfsZs8Y+of+s=";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE =
    if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [ libcap_ng libseccomp ];

  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with maintainers; [ qyliss astro ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 /* and */ bsd3 ];
  };
}
