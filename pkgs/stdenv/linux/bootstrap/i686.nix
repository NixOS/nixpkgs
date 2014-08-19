let

  fetch = { file, sha256 }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/i686/r24519/${file}";
    inherit sha256;
    executable = true;
  };

in {
  sh = fetch {
    file = "sh";
    sha256 = "1l6sdhyqjlh4m5gj3pfpi8aisp1m012lpwxfcc4v1x8g429mflmy";
  };

  bzip2 = fetch {
    file = "bzip2";
    sha256 = "1p5nkrdn52jm6rsx8x3wwjpsh83f2qsjl1qckkgnkplwhj23zjp7";
  };

  mkdir = fetch {
    file = "mkdir";
    sha256 = "02ff7i9ph9ahiapsg2v9c3pwr7sl73sk4n7ic112ljkrgwkail33";
  };

  cpio = fetch {
    file = "cpio";
    sha256 = "046if3aqqramyhrn2yxrjf4bfkl8x1bcqxhvi7ml9nrv9smx8irg";
  };

  curl = fetch {
    file = "curl.bz2";
    sha256 = "1v0yfb4gcdyqpl2fxlxjh337r28c23iqm7vwck4p4643xd55di7q";
  };

  bootstrapTools = {
    url = http://tarballs.nixos.org/stdenv-linux/i686/r24519/bootstrap-tools.cpio.bz2;
    sha256 = "0imypaxy6piwbk8ff2y1nr7yk49pqmdgdbv6g8miq1zs5yfip6ij";
  };
}
