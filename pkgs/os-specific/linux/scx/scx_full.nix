{
  lib,
  scx,
}:
scx.cscheds.overrideAttrs (oldAttrs: {
  pname = "scx_full";
  postInstall = (oldAttrs.postInstall or "") + ''
    cp ${lib.getBin scx.rustscheds}/bin/* ${placeholder "out"}/bin/
  '';

  meta = oldAttrs.meta // {
    description = "Sched-ext C and Rust userspace schedulers";
    longDescription = ''
      This includes C based schedulers such as scx_central, scx_flatcg,
      scx_pair, scx_qmap, scx_simple, scx_userland and Rust based schedulers
      like scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';
    homepage = "https://github.com/sched-ext/scx";
  };
})
