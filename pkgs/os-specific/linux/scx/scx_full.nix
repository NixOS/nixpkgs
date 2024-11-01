{
  stdenv,
  lib,
  scx,
  mkScxScheduler,
}:
scx.csheds.overrideAttrs (oldAttrs: {
  pname = "scx_full";
  postInstall =
    (oldAttrs.postInstall or "")
    + ''
      cp ${lib.getExe scx.bpfland} $out/bin/
      cp ${lib.getExe scx.lavd} $out/bin/
      cp ${lib.getExe scx.layered} $out/bin/
      cp ${lib.getExe scx.rlfifo} $out/bin/
      cp ${lib.getExe scx.rustland} $out/bin/
      cp ${lib.getExe scx.rusty} $out/bin/
    '';

  meta = oldAttrs.meta // {
    description = "Sched-ext C and Rust userspace schedulers";
    longDescription = ''
      This includes C based schedulers such as scx_central, scx_flatcg,
      scx_pair, scx_qmap, scx_simple, scx_userland and Rust based schedulers
      like scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.
    '';
  };
})
