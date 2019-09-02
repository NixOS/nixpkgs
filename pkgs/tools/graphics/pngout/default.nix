{stdenv, fetchurl}:

let
  folder = if stdenv.hostPlatform.system == "i686-linux" then "i686"
  else if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64"
  else throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  name = "pngout-20150319";

  src = fetchurl {
    url = http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz;
    sha256 = "0iwv941hgs2g7ljpx48fxs24a70m2whrwarkrb77jkfcd309x2h7";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${folder}/pngout $out/bin
    
    ${if stdenv.hostPlatform.system == "i686-linux" then ''
        patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux.so.2 $out/bin/pngout
      '' else if stdenv.hostPlatform.system == "x86_64-linux" then ''
        patchelf --set-interpreter ${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/pngout
      '' else ""}
  '';

  meta = {
    description = "A tool that aggressively optimizes the sizes of PNG images";
    license = stdenv.lib.licenses.unfree;
    homepage = http://advsys.net/ken/utils.htm;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
