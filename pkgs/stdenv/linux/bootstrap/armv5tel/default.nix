let

  fetch = { file, sha256 }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/r18744/${file}";
    inherit sha256;
    executable = true;
  };

in {
  sh = fetch {
    file = "sh";
    sha256 = "1kv3gc8h209rjc5i0rzzc4pjxq23kzq25iff89in05c9vl20mn4n";
  };

  bzip2 = fetch {
    file = "bzip2";
    sha256 = "090jrj099wl33q0iq092iljilam39pv8acli59m2af0fa9z0d9f0";
  };

  mkdir = fetch {
    file = "mkdir";
    sha256 = "01s8myfvi559dsxvbanxw71vxzjv49k4gi1qh0ak6l0qx0xq602b";
  };

  cpio = fetch {
    file = "cpio";
    sha256 = "07snc8l0mn84w2xrvdmc5yfpmlbrvl2bar8wipbpvm43nzz2qbzs";
  };

  ln = fetch {
    file = "ln";
    sha256 = "0m9fz02bashpfgwfkxmrp4wa8a5r3il52bclvf6z36vsam0vx56d";
  };

  curl = fetch {
    file = "curl.bz2";
    sha256 = "19yqdjqi31zlnqn8ss2ml60iq2a1vrwfw6dmvjqp6qbxmh7yb8n8";
  };

  bootstrapTools = {
    url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/r18744/bootstrap-tools.cpio.bz2";
    sha256 = "1rn4n5kilqmv62dfjfcscbsm0w329k3gyb2v9155fsi1sl2cfzcb";
  };
}
