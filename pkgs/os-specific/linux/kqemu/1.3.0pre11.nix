args : with args;
rec {
  name = "kqemu-"+version;
  src = fetchurl {
    url = http://www.nongnu.org/qemu/kqemu-1.3.0pre11.tar.gz;
    sha256 = "03svg2x52ziglf9r9irf6ziiz8iwa731fk1mdskwdip5jxbyy6jl";
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
    sed -e '/linux\/ioctl.h/a#include <linux\/sched.h>' -i kqemu-linux.c
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
    description = "Kernel module for Qemu acceleration";
  }; 
}
