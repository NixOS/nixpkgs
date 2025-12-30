{
  lib,
  rustPlatform,
  rust-cbindgen,
  expect,
  stdenv,
  fetchFromGitLab,
}:
rustPlatform.buildRustPackage {
  pname = "relibc";
  version = "0.2.5";

  src = fetchFromGitLab {
    owner = "redox-os";
    repo = "relibc";
    rev = "0e506e97af6a834386cc424f0cb500866a3d658d";
    hash = "sha256-1+1c0RrjtQqaY1Fy/5MgM5tYvd4Sbj+vxJvdhDzi95Q=";
    fetchSubmodules = true;
    domain = "gitlab.redox-os.org";
  };

  cargoHash = "sha256-2NdfPp4ndfE3y+CQ6eTG/gy7HrSDC6QW2C1BiP8uDFI=";

  RUSTC_BOOTSTRAP = 1;
  TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  # error: Usage of `RUSTC_WORKSPACE_WRAPPER` requires `-Z unstable-options`
  auditable = false;

  doCheck = false;
  patchPhase = ''
    runHook prePatch

    patchShebangs --build renamesyms.sh stripcore.sh

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    make CC=gcc AR=ar LD=ld NM=nm CARGO_COMMON_FLAGS="" all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    DESTDIR=$out make CC=gcc AR=ar LD=ld NM=nm install

    runHook postInstall
  '';

  nativeBuildInputs = [
    rust-cbindgen
    expect
  ];

  meta = {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eveeifyeve ];
    platforms = lib.platforms.redox ++ lib.platforms.linux;
    teams = [ lib.teams.redox ];
  };
}
