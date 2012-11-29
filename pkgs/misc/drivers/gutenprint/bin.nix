{ stdenv, fetchurl, rpm, cpio, zlib }:

assert stdenv.system == "x86_64-linux";

/* usage: (sorry, its still impure but works!)

impure directory:
mkdir /opt/gutenprint; sudo cp -r $(nix-build -A gutenprintBin -f $NIXPGS_ALL) /opt/gutenprint

add the following lines to bindirCmds property of  printing/cupsd.nix:

  ln -s ${pkgs.gutenprintBin}/lib/cups/backend/* $out/lib/cups/backend/
  ln -s ${pkgs.gutenprintBin}/lib/cups/filter/* $out/lib/cups/filter/
  mkdir -p $out/lib/cups/model
  cat ${pkgs.gutenprintBin}/ppds/Canon/Canon-PIXMA_iP4000-gutenprint.5.0.sim-en.ppd.gz |gunzip > $out/lib/cups/model/Canon-PIXMA_iP4000-gutenprint.5.0.sim-en.ppd
  sed -i 's@/opt/gutenprint/cups@${pkgs.gutenprintBin}/cups@' $out/lib/cups/model/Canon-PIXMA_iP4000-gutenprint.5.0.sim-en.ppd

Then rebuild your system and add your printer using the the localhost:603 cups web interface
select the extracted .ppd file which can be found in the model directory of
sed -n 's/^ServerBin //p' $(sed -n 's/respawn.*-c \(.*''\) -F.*''/\1/p' /etc/event.d/cupsd)
(sorry, cups still doesn't see it. You could copy it into /nix/store/
*-cups/lib/cups/model/ and you would be able to select canon -> PIXMA 4000
then. I've tried that.

TODO tidy this all up. Find source instead of binary. Fix paths ... Find out how to check ink levels etc
 
*/

stdenv.mkDerivation {
  name = "cups-gutenprint-binary-5.0.1";

  src = if stdenv.system == "x86_64-linux" then fetchurl {
    url = http://www.openprinting.org/download/printdriver/debian/dists/lsb3.1/main/binary-amd64/gutenprint_5.0.1-1lsb3.1_amd64.deb;
    sha256 = "0an5gba6r6v54r53s2gj2fjk8fzpl4lrksjas2333528b0k8gbbc";
  } else throw "TODO"; # get from openprint.com -> drivers -> gutenprint

  buildInputs = [ rpm cpio ];

  phases = "buildPhase";

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc zlib ];

  buildPhase = ''
    ar -x $src data.tar.gz
    tar xfz data.tar.gz
    cp -r opt/gutenprint $out

    for p in \
        $out/cups/lib/driver/gutenprint.5.0 \
        $out/bin/{escputil,cups-calibrate} \
        $out/cups/lib/driver/gutenprint.5.0 \
        $out/cups/lib/filter/{rastertogutenprint.5.0,commandtocanon,commandtoepson} \
        $out/cups/lib/backend/{canon,epson} \
        $out/sbin/cups-genppd.5.0 \
      ; do
      patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          --set-rpath $libPath $p
    done
    
    mkdir $out/lib
    ln -s $out/cups/lib $out/lib/cups
  '';

  meta = {
    description = "Some additional CUPS drivers including Canon drivers";
  };
}
