{ lib, stdenv, rustPlatform, fetchFromGitLab, libcap_ng, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.9.0";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "sha256-wbfx6Ennyl4qWODRAtJ3eydSRFfE/ANCSl2GA9oq90A=";
  };

  separateDebugInfo = true;

  cargoHash = "sha256-Vdvk700NjjCTSD0Lscr5ckxsYa4pDJdmV7Kgr++0GFY=";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE =
    if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [ libcap_ng libseccomp ];

  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with maintainers; [ qyliss astro ];
    mainProgram = "virtiofsd";
    platforms = platforms.linux;
    license = with licenses; [ asl20 /* and */ bsd3 ];
  };
}
