{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" rec {
  schedulerName = "scx_layered";

  cargoRoot = "scheds/rust/scx_layered";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_layered/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_layered
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_layered $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      Highly configurable multi-layer BPF/userspace hybrid scheduler.
      It is designed to be highly customizable, and can be targeted for specific applications.
    '';
    mainProgram = "scx_layered";
  };
}
