{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.260";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1xcgqvk1g3l9bidpx377rbbwzvyxb0sbkszlk722bj7vk6c4asmq";
  };
} // (args.argsOverride or {}))
