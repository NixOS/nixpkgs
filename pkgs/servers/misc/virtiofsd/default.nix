{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  libcap_ng,
  libseccomp,
}:

rustPlatform.buildRustPackage rec {
  pname = "virtiofsd";
  version = "1.10.1";

  src = fetchFromGitLab {
    owner = "virtio-fs";
    repo = "virtiofsd";
    rev = "v${version}";
    sha256 = "sha256-qHrgNuPDEtFzucE6ACPemUcjEqOvbo4xV0ru4bP3ATE=";
  };

  separateDebugInfo = true;

  cargoHash = "sha256-BVl4Inr7ZLnilkPVTD2cjJx9RuqB0Mg230o2c2TLw3I=";

  LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
  LIBCAPNG_LINK_TYPE = if stdenv.hostPlatform.isStatic then "static" else "dylib";

  buildInputs = [
    libcap_ng
    libseccomp
  ];

  postConfigure = ''
    sed -i "s|/usr/libexec|$out/bin|g" 50-virtiofsd.json
  '';

  postInstall = ''
    install -Dm644 50-virtiofsd.json "$out/share/qemu/vhost-user/50-virtiofsd.json"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    description = "vhost-user virtio-fs device backend written in Rust";
    maintainers = with maintainers; [
      qyliss
      astro
    ];
    mainProgram = "virtiofsd";
    platforms = platforms.linux;
    license = with licenses; [
      asl20 # and
      bsd3
    ];
  };
}
