{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" rec {
  schedulerName = "scx_rustland";

  cargoRoot = "scheds/rust/scx_rustland";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_rustland/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_rustland
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_rustland $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      Made of a BPF component (scx_rustland_core) that implements the low level sched-ext functionalities
      and a user-space counterpart (scheduler), written in Rust, that implements the actual scheduling policy.
      It is designed to prioritize interactive workloads over background CPU-intensive workloads. Typical use
      case involves low-latency interactive applications, such as gaming, video conferencing and live streaming.
    '';
    mainProgram = "scx_rustland";
  };
}
