args : with args;
rec {
  name = "kqemu-"+version;
  src = fetchurl {
    url = http://www.nongnu.org/qemu/kqemu-1.4.0pre1.tar.gz;
    sha256 = "14dlmawn3gia1j401ag5si5k1a1vav7jpv86rl37p1hwmr7fihxs";
  };

  buildInputs = [];
  configureFlags = [''--PREFIx=$out'' ''--kernel-path=$(ls -d ${kernel}/lib/modules/*/build)''];
  debugStep = fullDepEntry (''
  	cat config-host.mak
  '') ["minInit"];
  preConfigure = fullDepEntry ('' 
    sed -e 's/`uname -r`/'"$(basename ${kernel}/lib/modules/*)"'/' -i install.sh
    sed -e '/kernel_path=/akernel_path=$out$kernel_path' -i install.sh
    sed -e '/depmod/d' -i install.sh
    cat install.sh
  '') ["minInit" "doUnpack"];
  fixInc = {
    text = ''
      sed -e '/#include/i#include <linux/sched.h>' -i kqemu-linux.c
    '';
    deps = ["minInit" "doUnpack"];
  };
  fixMemFunc = {
    text=''
      sed -e 's/memset/mymemset/g; s/memcpy/mymemcpy/g; s/void [*]my/static void *my/g' -i common/kernel.c
    '';
    deps = ["minInit" "doUnpack"];
  };
  phaseNames = ["fixInc" "fixMemFunc" "preConfigure" "doConfigure" "debugStep" "doMakeInstall"];

  meta = {
    description = " Kernel module for Qemu acceleration ";
  }; 
}
