{stdenv, fetchgit}:

let
  repo = "git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git";
  src  = fetchgit {
      url  = repo;
      rev  = "15888a2eab052ac3d3f49334e4f6f05f347a516e";
      sha256 = "df63b71dd56ad85f97784076eeced76849e95cb30a9909e8322f7fdd54f227b4";
    };
  meta = {
    description = "GIT repo of the linux firmware binaries";
    homepage = repo;
  };
in stdenv.lib.setName "linux-firmware" (stdenv.lib.addMetaAttrs meta src)
