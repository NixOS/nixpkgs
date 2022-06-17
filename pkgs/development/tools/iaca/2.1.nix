{ lib, stdenv, makeWrapper, requireFile, gcc, unzip }:
with lib;

# v2.1: last version with NHM/WSM arch support
stdenv.mkDerivation rec {
  pname = "iaca";
  version = "2.1";
  src = requireFile {
    name = "iaca-version-${version}-lin64.zip";
    sha256 = "11s1134ijf66wrc77ksky9mnb0lq6ml6fzmr86a6p6r5xclzay2m";
    url = "https://software.intel.com/en-us/articles/intel-architecture-code-analyzer-download";
  };
  unpackCmd = ''${unzip}/bin/unzip "$src" -x __MACOSX/ __MACOSX/iaca-lin64/ __MACOSX/iaca-lin64/._.DS_Store'';
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp bin/iaca $out/bin/
    cp lib/* $out/lib
  '';
  preFixup = let libPath = makeLibraryPath [ stdenv.cc.cc.lib gcc ]; in ''
    patchelf \
        --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
        --set-rpath $out/lib:"${libPath}" \
        $out/bin/iaca
  '';
  postFixup = "wrapProgram $out/bin/iaca --set LD_LIBRARY_PATH $out/lib";
  meta = {
    description = "Intel Architecture Code Analyzer";
    homepage = "https://software.intel.com/en-us/articles/intel-architecture-code-analyzer/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kazcw ];
  };
}
