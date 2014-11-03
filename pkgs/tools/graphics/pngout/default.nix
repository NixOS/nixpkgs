{stdenv, fetchurl}:

let
  folder = if stdenv.system == "i686-linux" then "i686"
  else if stdenv.system == "x86_64-linux" then "x86_64"
  else throw "Unsupported system: ${stdenv.system}";
in
stdenv.mkDerivation {
  name = "pngout-20130221";

  src = fetchurl {
    url = http://static.jonof.id.au/dl/kenutils/pngout-20130221-linux.tar.gz;
    sha256 = "1qdzmgx7si9zr7wjdj8fgf5dqmmqw4zg19ypg0pdz7521ns5xbvi";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${folder}/pngout $out/bin
    
    ${if stdenv.system == "i686-linux" then ''
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 $out/bin/pngout
      '' else if stdenv.system == "x86_64-linux" then ''
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/pngout
      '' else ""}
  '';

  meta = {
    description = "A tool that agressively optimizes the sizes of PNG images";
    license = stdenv.lib.licenses.unfree;
    homepage = http://advsys.net/ken/utils.htm;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
