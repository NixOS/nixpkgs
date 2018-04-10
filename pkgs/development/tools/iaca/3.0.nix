{ stdenv, requireFile, patchelf, unzip }:
assert stdenv.system == "x86_64-linux";
with stdenv.lib;

stdenv.mkDerivation {
  name = "iaca-3.0";
  src = requireFile {
    name = "iaca-version-v3.0-lin64.zip";
    sha256 = "0qd81bxg269cwwvfmdp266kvhcl3sdvhrkfqdrbmanawk0w7lvp1";
    url = "https://software.intel.com/en-us/articles/intel-architecture-code-analyzer-download";
  };
  unpackCmd = ''${unzip}/bin/unzip "$src"'';
  installPhase = ''
    mkdir -p $out/bin
    cp iaca $out/bin
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/iaca
  '';
  meta = {
    description = "Intel Architecture Code Analyzer";
    homepage = https://software.intel.com/en-us/articles/intel-architecture-code-analyzer/;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kazcw ];
  };
}
