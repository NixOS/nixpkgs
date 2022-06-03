{ lib, stdenv, requireFile, unzip }:
with lib;

stdenv.mkDerivation rec {
  pname = "iaca";
  version = "3.0";
  src = requireFile {
    name = "iaca-version-v${version}-lin64.zip";
    sha256 = "0qd81bxg269cwwvfmdp266kvhcl3sdvhrkfqdrbmanawk0w7lvp1";
    url = "https://software.intel.com/en-us/articles/intel-architecture-code-analyzer-download";
  };
  unpackCmd = ''${unzip}/bin/unzip "$src"'';
  installPhase = ''
    mkdir -p $out/bin
    cp iaca $out/bin
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $out/bin/iaca
  '';
  meta = {
    description = "Intel Architecture Code Analyzer";
    homepage = "https://software.intel.com/en-us/articles/intel-architecture-code-analyzer/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kazcw ];
  };
}
