args : with args;
rec {
  name = "kqemu-"+version;
  src = fetchurl {
    url = http://bellard.org/qemu/kqemu-1.4.0pre1.tar.gz;
    sha256 = "14dlmawn3gia1j401ag5si5k1a1vav7jpv86rl37p1hwmr7fihxs";
  };

  buildInputs = [];
  configureFlags = [''--PREFIx=$out'' ''--kernel-path=$(ls -d ${kernel}/lib/modules/*/build)''];
  debugStep = FullDepEntry (''
  	cat config-host.mak
  '') ["minInit"];
  preConfigure = FullDepEntry ('' 
    sed -e 's/`uname -r`/'"$(basename ${kernel}/lib/modules/*)"'/' -i install.sh
    sed -e '/kernel_path=/akernel_path=$out$kernel_path' -i install.sh
    sed -e '/depmod/d' -i install.sh
    cat install.sh
  '') ["minInit" "doUnpack"];

  phaseNames = ["preConfigure" "doConfigure" "debugStep" "doMakeInstall"];

  meta = {
    description = " Kernel module for Qemu acceleration ";
  }; 
}
