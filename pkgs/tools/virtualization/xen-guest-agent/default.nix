{
  lib,
  fetchFromGitLab,
  rustPlatform,
  llvmPackages,
  xen-light,
}:
rustPlatform.buildRustPackage rec {
  pname = "xen-guest-agent";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "xen-project";
    repo = pname;
    rev = version;
    hash = "sha256-Csio24ofj+p0j/R0av/28P/KCNXhmcF+r8xGJEfoHjQ=";
  };

  cargoHash = "sha256-XWDDzSu88zCIwMuvkFjCb98DzXHvW2IP9u3EbpAMIgw=";

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${xen-light}/include";
    RUSTFLAGS = "-L ${xen-light}/lib";
  };

  nativeBuildInputs = [llvmPackages.clang xen-light];

  postFixup = ''
    patchelf $out/bin/xen-guest-agent --add-rpath ${xen-light}/lib
  '';

  meta = with lib; {
    description = "Xen agent running in Linux/BSDs (POSIX) VMs";
    homepage = "https://gitlab.com/xen-project/xen-guest-agent";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [matdibu];
  };
}
