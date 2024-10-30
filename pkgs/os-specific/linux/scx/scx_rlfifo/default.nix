{
  stdenv,
  lib,
  mkScxScheduler,
}:

mkScxScheduler "rust" {
  schedulerName = "scx_rlfifo";

  cargoRoot = "scheds/rust/scx_rlfifo";
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    rm Cargo.toml Cargo.lock
    ln -fs ${./Cargo.lock} scheds/rust/scx_rlfifo/Cargo.lock
  '';

  preBuild = ''
    cd scheds/rust/scx_rlfifo
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp target/${stdenv.targetPlatform.config}/release/scx_rlfifo $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Sched-ext Rust userspace scheduler";
    longDescription = ''
      scx_rlfifo is a simple FIFO scheduler runs in user-space, based on the
      scx_rustland_core framework. Not for production use, but useful to test as a
      baseline against complex scheduling polices or for a basic FIFO scheduling approach.
    '';
    mainProgram = "scx_rlfifo";
  };
}
