{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" rec {
  schedulerName = "scx_bpfland";

  cargoRoot = "scheds/rust/scx_bpfland";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_bpfland/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_bpfland
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_bpfland $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      Vruntime-based Sched-ext scheduler that prioritizes interactive workloads. This
      scheduler is derived from scx_rustland, but it is fully implemented in BPF. It
      has a minimal user-space Rust part to process command line options, collect metrics
      and log out scheduling statistics. The BPF part makes all the scheduling decisions.
    '';
    mainProgram = "scx_bpfland";
  };
}
