{ sudo, fetchpatch, autoreconfHook, lib }:

sudo.overrideAttrs ({ nativeBuildInputs ? [], configureFlags ? [], patches ? [], meta, ... }: {
  patches = patches ++ [
    (fetchpatch {
      url = "https://github.com/sudo-project/sudo/commit/4b365300a70900f000886729431be93dbbc323b0.patch";
      sha256 = "sha256-1CB2vBf5FIsDeTBllklcSdCHw59pKtixwGGALlsHScM=";
    })
  ];
  nativeBuildInputs = nativeBuildInputs ++ [ autoreconfHook ];
  configureFlags = configureFlags ++ [
    "--enable-static-sudoers"
  ];
  meta = meta // {
    maintainers = meta.maintainers ++ [ lib.maintainers.ma27 ];
    description = "`sudo(8)`, but with `--enable-static-sudoers`";
  };
})
