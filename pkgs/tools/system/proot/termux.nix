{ proot, stdenv, fetchFromGitHub, ... }@args:

let
  # Enable overriding of proot arguments via proot-termux.override.
  # Proot is not a function of `proot`, so this must be filtered out.
  vanilla = proot.override
    (stdenv.lib.filterAttrs (n: _: n != "proot") args);
in vanilla.overrideAttrs (old: {
  pname = "proot-termux";
  version = "20190505";

  src = fetchFromGitHub {
    repo = "proot";
    owner = "termux";
    rev = "0717de26d1394fec3acf90efdc1d172e01bc932b";
    sha256 = "1g0r3a67x94sgffz3gksyqk8r06zynfcgfdi33w6kzxnb03gbm4m";
  };

  meta.homepage = https://github.com/termux/proot;
  meta.description = "Termux fork of proot, a user-space implementation of "
    + "chroot, mount --bind and binfmt_misc";
  meta.maintainers = [ stdenv.lib.maintainers.jorsn ] ++ old.meta.maintainers;
})
