{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1-rc4";
  modDirVersion = "5.1.0-rc4";
  extraMeta.branch = "5.1";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1cqr80b3jfr4g48fpni0pj2p5zs9930q6k6m9xjjdnsrhax1isr6";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
