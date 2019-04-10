{ fetchurl
, linux_4_4
, linux_4_9
, linux_4_14
, linux_4_19
, linux_5_0
}:

#
# rt kernels
# ==========
#
# Here are the linux kernels with the realtime patchset applied.
# What we do here is overriding the "original" kernel by replacing the
# sources with the sources of the realtime-kernel git tree .tar.gz exports.
# Because of this, we also get the patches applied in the all-packages.nix
# file automatically.
#
# Howto Update
# ------------
#
# For updating an expression here, go to
#
#   https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git/
#
# and find the latest kernel .tar.gz files, then update the version and sha256
# in the expression below.
#

let
  rtKernel = { origKernel, version,  sha256 } @ args:
  origKernel.overrideAttrs (o: rec {
    version = args.version;
    src = fetchurl {
      sha256 = args.sha256;
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git/snapshot/linux-stable-rt-${args.version}.tar.gz";
    };
  });
in
{
  linux_4_4_rt = rtKernel {
    origKernel = linux_4_4;
    version = "4.4.177-rt179";
    sha256 = "16fmaww65n194pm9qd1ld17d4w84m10krbd1dyxjmlcn5cf9mq75";
  };

  linux_4_9_rt = rtKernel {
    origKernel = linux_4_9;
    version = "4.9.146-rt125";
    sha256 = "1j2zsf4a72c1k98bhsiiw0fhg3sazaixgbrw076fn2fgwgqh1sjb";
  };

  linux_4_14_rt = rtKernel {
    origKernel = linux_4_14;
    version = "4.14.109-rt57";
    sha256 = "17la2fb06swyvdm5x7005c7hk13n8s5hbvqfxb2dzlx3gzf1sj4q";
  };

  linux_4_19_rt = rtKernel {
    origKernel = linux_4_19;
    version = "4.19.31-rt18";
    sha256 = "0a40bhrc803ngsr0qy4r9igk9sal2r2sqk47y68q8nhrf4z1nzbw";
  };

  linux_5_0_rt = rtKernel {
    origKernel = linux_5_0;
    version = "5.0.3-rt1";
    sha256 = "0k21xqzhg1281661gqc0r35as1av8nf0f0f6zsvm1fw5lxgb0fkh";
  };
}
