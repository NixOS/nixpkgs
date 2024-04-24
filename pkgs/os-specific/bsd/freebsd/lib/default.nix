{ version }:

{
  inherit version;

  mkBsdArch = stdenv':  {
    x86_64 = "amd64";
    aarch64 = "arm64";
    i486 = "i386";
    i586 = "i386";
    i686 = "i386";
  }.${stdenv'.hostPlatform.parsed.cpu.name}
    or stdenv'.hostPlatform.parsed.cpu.name;

  install-wrapper = builtins.readFile ./install-wrapper.sh;
}
