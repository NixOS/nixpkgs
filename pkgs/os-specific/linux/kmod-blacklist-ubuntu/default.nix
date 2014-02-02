{ stdenv, fetchbzr }:

stdenv.mkDerivation rec {
  name = "blacklist-ubuntu-${builtins.toString src.revision}"; # Saucy

  src = fetchbzr {
    url = meta.homepage;
    sha256 = "0ci4b5dxzirc27zvgpr3s0pa78gjmfjwprmvyplxhwxb765la9v9";
    revision = 13;
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir "$out"
    for f in "$src"/debian/modprobe.d/*.conf; do
      echo "''\n''\n## file: "`basename "$f"`"''\n''\n" >> "$out"/modprobe.conf
      cat "$f" >> "$out"/modprobe.conf
    done
  '';

  #TODO: iwlwifi.conf has some strange references

  meta = {
    homepage = https://code.launchpad.net/~ubuntu-branches/ubuntu/saucy/kmod/saucy;
    description = "Linux kernel module blacklists from Ubuntu";
  };
}
