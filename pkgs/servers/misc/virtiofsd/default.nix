{ lib, stdenv, rustPlatform, fetchFromGitLab, fetchpatch, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.7.0";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "sha256-YihxXoWcJHy7IT27x9TOM46R66IfosLz8ZKFsWCL3K0=";
  };

  cargoHash = "sha256-lNtZFcbOITP9S7N/EevMs2XZcDnF5JDbGNPyn5r5Q0Q=";

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
