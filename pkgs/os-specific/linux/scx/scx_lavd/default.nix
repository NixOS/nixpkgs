{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" {
  schedulerName = "scx_lavd";

  cargoRoot = "scheds/rust/scx_lavd";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_lavd/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_lavd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_lavd $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      BPF scheduler that implements an LAVD (Latency-criticality Aware Virtual Deadline)
      scheduling algorithm. typical use case involves highly interactive applications,
      such as gaming, which requires high throughput and low tail latencies.
    '';
    mainProgram = "scx_lavd";
  };
}
