let
  fetch = { file, sha256 }:
    let
      nixFetchurl = import <nix/fetchurl.nix>;
      args = {
        url = "file://${builtins.toString ./.}/${file}";
        inherit sha256;
        executable = true;
      };
    in if (builtins.functionArgs nixFetchurl) ? executable
      then nixFetchurl args
      else derivation {
        name = file;
        builder = "/bin/sh";

        system = builtins.currentSystem;

        args = [ "-c" "echo $message; exit 1" ];

        message = ''
          Sorry, this version of nix cannot download all of the bootstrap tools.
          Please download ${args.url}, make it executable, add it to the store
          with `nix-store --add', and try again.
        '';

        outputHashAlgo = "sha256";

        outputHash = args.sha256;

        outputHashMode = "recursive";

        preferLocalBuild = true;
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

  ln = fetch {
    file = "ln";
    sha256 = "06vr474i3x55p0rnqa87yx7dzf4qdfpfg201mks39id43cjm9f8j";
  };

  curl = fetch {
    file = "curl.bz2";
    sha256 = "1v0yfb4gcdyqpl2fxlxjh337r28c23iqm7vwck4p4643xd55di7q";
  };

  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/i686/r24519/bootstrap-tools.cpio.bz2;
    sha256 = "0imypaxy6piwbk8ff2y1nr7yk49pqmdgdbv6g8miq1zs5yfip6ij";
  };
}
