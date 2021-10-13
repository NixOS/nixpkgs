# ████████╗██╗  ██╗███████╗    ███████╗███████╗███████╗██████╗ ███████╗
# ╚══██╔══╝██║  ██║██╔════╝    ██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝
#    ██║   ███████║█████╗      ███████╗█████╗  █████╗  ██║  ██║███████╗
#    ██║   ██╔══██║██╔══╝      ╚════██║██╔══╝  ██╔══╝  ██║  ██║╚════██║
#    ██║   ██║  ██║███████╗    ███████║███████╗███████╗██████╔╝███████║
#    ╚═╝   ╚═╝  ╚═╝╚══════╝    ╚══════╝╚══════╝╚══════╝╚═════╝ ╚══════╝
#
# These seeds are the binary blobs at the core of stdenv.

let
  fetchurl = import <nix/fetchurl.nix>;
in
rec {
  darwin = {
    aarch64 =
      let
        fetch = { file, sha256, executable ? true }: fetchurl {
          url = "http://tarballs.nixos.org/stdenv-darwin/aarch64/20acd4c4f14040485f40e55c0a76c186aa8ca4f3/${file}";
          inherit sha256 executable;
        }; in
      {
        sh = fetch { file = "sh"; sha256 = "17m3xrlbl99j3vm7rzz3ghb47094dyddrbvs2a6jalczvmx7spnj"; };
        bzip2 = fetch { file = "bzip2"; sha256 = "1khs8s5klf76plhlvlc1ma838r8pc1qigk9f5bdycwgbn0nx240q"; };
        mkdir = fetch { file = "mkdir"; sha256 = "1m9nk90paazl93v43myv2ay68c1arz39pqr7lk5ddbgb177hgg8a"; };
        cpio = fetch { file = "cpio"; sha256 = "17pxq61yjjvyd738fy9f392hc9cfzkl612sdr9rxr3v0dgvm8y09"; };
        tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "1v2332k33akm6mrm4bj749rxnnmc2pkbgcslmd0bbkf76bz2ildy"; executable = false; };
      };
    x86_64 =
      let
        fetch = { file, sha256, executable ? true }: fetchurl {
          url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/05ef940b94fe76e7ac06ea45a625adc8e4be96f9/${file}";
          inherit sha256 executable;
        }; in
      {
        sh = fetch { file = "sh"; sha256 = "sha256-igMAVEfumFv/LUNTGfNi2nSehgTNIP4Sg+f3L7u6SMA="; };
        bzip2 = fetch { file = "bzip2"; sha256 = "sha256-K3rhkJZipudT1Jgh+l41Y/fNsMkrPtiAsNRDha/lpZI="; };
        mkdir = fetch { file = "mkdir"; sha256 = "sha256-VddFELwLDJGNADKB1fWwWPBtIAlEUgJv2hXRmC4NEeM="; };
        cpio = fetch { file = "cpio"; sha256 = "sha256-SWkwvLaFyV44kLKL2nx720SvcL4ej/p2V/bX3uqAGO0="; };
        tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "sha256-b65dXbIm6o6s6U8tAiGpR6SMfvfn/VFcZgTHBetJZis="; executable = false; };
      };
  };
  linux = {
    glibc = {
      aarch64-linux = {
        busybox = fetchurl {
          url = "http://tarballs.nixos.org/stdenv-linux/aarch64/bb3ef8a95c9659596b8a34d27881cd30ffea2f9f/busybox";
          sha256 = "12qcml1l67skpjhfjwy7gr10nc86gqcwjmz9ggp7knss8gq8pv7f";
          executable = true;
        };
        bootstrapTools = fetchurl {
          url = "http://tarballs.nixos.org/stdenv-linux/aarch64/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz";
          sha256 = "d3f1bf2a1495b97f45359d5623bdb1f8eb75db43d3bf2059fc127b210f059358";
        };
      };
      armv5tel-linux = {
        # Note: do not use Hydra as a source URL. Ask a member of the
        # infrastructure team to mirror the job.
        busybox = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv5tel.dist/latest
          # from build: https://hydra.nixos.org/build/114203025
          url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
          # note: the following hash is different than the above hash, due to executable = true
          sha256 = "0qxp2fsvs4phbc17g9npj9bsm20ylr8myi5pivcrmxm5qqflgi8d";
          executable = true;
        };
        bootstrapTools = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv5tel.dist/latest
          # from build: https://hydra.nixos.org/build/114203025
          url = "http://tarballs.nixos.org/stdenv-linux/armv5tel/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
          sha256 = "28327343db5ecc7f7811449ec69280d5867fa5d1d377cab0426beb9d4e059ed6";
        };
      };
      armv6l-linux = {
        # Note: do not use Hydra as a source URL. Ask a member of the
        # infrastructure team to mirror the job.
        busybox = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv6l.dist/latest
          # from build: https://hydra.nixos.org/build/114202834
          url = "http://tarballs.nixos.org/stdenv-linux/armv6l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
          # note: the following hash is different than the above hash, due to executable = true
          sha256 = "1q02537cq56wlaxbz3s3kj5vmh6jbm27jhvga6b4m4jycz5sxxp6";
          executable = true;
        };
        bootstrapTools = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv6l.dist/latest
          # from build: https://hydra.nixos.org/build/114202834
          url = "http://tarballs.nixos.org/stdenv-linux/armv6l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
          sha256 = "0810fe74f8cd09831f177d075bd451a66b71278d3cc8db55b07c5e38ef3fbf3f";
        };
      };
      armv7l-linux = {
        # Note: do not use Hydra as a source URL. Ask a member of the
        # infrastructure team to mirror the job.
        busybox = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
          # from build: https://hydra.nixos.org/build/114203060
          url = "http://tarballs.nixos.org/stdenv-linux/armv7l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
          # note: the following hash is different than the above hash, due to executable = true
          sha256 = "18qc6w2yykh7nvhjklsqb2zb3fjh4p9r22nvmgj32jr1mjflcsjn";
          executable = true;
        };
        bootstrapTools = fetchurl {
          # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv7l.dist/latest
          # from build: https://hydra.nixos.org/build/114203060
          url = "http://tarballs.nixos.org/stdenv-linux/armv7l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
          sha256 = "cf2968e8085cd3e6b3e9359624060ad24d253800ede48c5338179f6e0082c443";
        };
      };

      i686-linux = {
        busybox = fetchurl {
          url = "http://tarballs.nixos.org/stdenv-linux/i686/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/busybox";
          sha256 = "ef4c1be6c7ae57e4f654efd90ae2d2e204d6769364c46469fa9ff3761195cba1";
          executable = true;
        };
        bootstrapTools = fetchurl {
          url = "http://tarballs.nixos.org/stdenv-linux/i686/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz";
          sha256 = "b9bf20315f8c5c0411679c5326084420b522046057a0850367c67d9514794f1c";
        };
      };
      mipsel-linux =
        let
          fetch = { file, sha256 }: fetchurl {
            url = "http://tarballs.nixos.org/stdenv-linux/loongson2f/r22849/${file}";
            inherit sha256;
            executable = true;
          };
        in
        {
          sh = fetch {
            file = "sh";
            sha256 = "02jjl49wdq85pgh61aqf78yaknn9mi3rcspbpk7hs9c4mida2rhf";
          };
          bzip2 = fetch {
            file = "bzip2";
            sha256 = "1qn27y3amj9c6mnjk2kyb59y0d2w4yv16z9apaxx91hyq19gf29z";
          };
          mkdir = fetch {
            file = "mkdir";
            sha256 = "1vbp2bv9hkyb2fwl8hjrffpywn1wrl1kc4yrwi2lirawlnc6kymh";
          };
          cpio = fetch {
            file = "cpio";
            sha256 = "0mqxwdx0sl7skxx6049mk35l7d0fnibqsv174284kdp4p7iixwa0";
          };
          ln = fetch {
            file = "ln";
            sha256 = "05lwx8qvga3yv8xhs8bjgsfygsfrcxsfck0lxw6gsdckx25fgi7s";
          };
          curl = fetch {
            file = "curl.bz2";
            sha256 = "0iblnz4my54gryac04i64fn3ksi9g3dx96yjq93fj39z6kx6151c";
          };
          bootstrapTools = fetchurl {
            url = "http://tarballs.nixos.org/stdenv-linux/loongson2f/r22849/cross-bootstrap-tools.cpio.bz2";
            sha256 = "00aavbk76qjj2gdlmpaaj66r8nzl4d7pyl8cv1gigyzgpbr5vv3j";
          };
        };
      x86_64-linux =
        # Use busybox for i686-linux since it works on x86_64-linux as well.
        linux.glibc.i686-linux //
        {
          bootstrapTools = fetchurl {
            url = "http://tarballs.nixos.org/stdenv-linux/x86_64/c5aabb0d603e2c1ea05f5a93b3be82437f5ebf31/bootstrap-tools.tar.xz";
            sha256 = "a5ce9c155ed09397614646c9717fc7cd94b1023d7b76b618d409e4fefd6e9d39";
          };
        };
    };
    musl = {
      aarch64-linux = {
        busybox = fetchurl {
          url = "https://wdtz.org/files/wjzsj9cmdkc70f78yh072483x8656nci-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/busybox";
          sha256 = "01s6bwq84wyrjh3rdsgxni9gkzp7ss8rghg0cmp8zd87l79y8y4g";
          executable = true;
        };
        bootstrapTools = fetchurl {
          url = "https://wdtz.org/files/wjzsj9cmdkc70f78yh072483x8656nci-stdenv-bootstrap-tools-aarch64-unknown-linux-musl/on-server/bootstrap-tools.tar.xz";
          sha256 = "0pbqrw9z4ifkijpfpx15l2dzi00rq8c5zg9ghimz5qgr5dx7f7cl";
        };
      };
      armv6l-linux = {
        busybox = fetchurl {
          url = "https://wdtz.org/files/xmz441m69qrlfdw47l2k10zf87fsya6r-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/busybox";
          sha256 = "01d0hp1xgrriiy9w0sd9vbqzwxnpwiyah80pi4vrpcmbwji36j1i";
          executable = true;
        };
        bootstrapTools = fetchurl {
          url = "https://wdtz.org/files/xmz441m69qrlfdw47l2k10zf87fsya6r-stdenv-bootstrap-tools-armv6l-unknown-linux-musleabihf/on-server/bootstrap-tools.tar.xz";
          sha256 = "1r9mz9w8y5jd7gfwfsrvs20qarzxy7bvrp5dlm41hnx6z617if1h";
        };
      };
      x86_64-linux = {
        busybox = fetchurl {
          url = "https://wdtz.org/files/gywxhjgl70sxippa0pxs0vj5qcgz1wi8-stdenv-bootstrap-tools/on-server/busybox";
          sha256 = "0779c2wn00467h76xpqil678gfi1y2p57c7zq2d917jsv2qj5009";
          executable = true;
        };
        bootstrapTools = fetchurl {
          url = "https://wdtz.org/files/gywxhjgl70sxippa0pxs0vj5qcgz1wi8-stdenv-bootstrap-tools/on-server/bootstrap-tools.tar.xz";
          sha256 = "1dwiqw4xvnm0b5fdgl89lz2qq45f6s9icwxn6n6ams71xw0dbqyi";
        };
      };
    };
  };
}
