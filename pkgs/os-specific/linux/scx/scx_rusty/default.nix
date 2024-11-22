{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" {
  schedulerName = "scx_rusty";

  cargoRoot = "scheds/rust/scx_rusty";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_rusty/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_rusty
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_rusty $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      Multi-domain, BPF/userspace hybrid scheduler. BPF portion of the scheduler does
      a simple round robin in each domain, and the userspace portion calculates the load
      factor of each domain, and informs BPF of how tasks should be load balanced accordingly.
      Rusty is designed to be flexible, accommodating different architectures and workloads.
    '';
    mainProgram = "scx_rusty";
  };
}
