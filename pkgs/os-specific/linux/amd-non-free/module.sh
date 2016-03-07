# Build an fglrx kernel module
source $stdenv/setup
set -x
# Handle/Build the kernel module.
cp -r $TMP/common/usr/include $out
kernelVersion=$(cd ${kernel}/lib/modules && ls)
kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/build)
linuxsources=$(echo ${kernel}/lib/modules/$kernelVersion/source)
# note: maybe the .config file should be used to determine this ?
# current kbuild infrastructure allows using CONFIG_* defines
# but ati sources don't use them yet..
# copy paste from make.sh
setSMP(){

  linuxincludes=$kernelBuild/include
  src_file=$linuxincludes/generated/autoconf.h

  [ -e $src_file ] || die "$src_file not found"

  if [ `cat $src_file | grep "#undef" | grep "CONFIG_SMP" -c` = 0 ]; then
    SMP=`cat $src_file | grep CONFIG_SMP | cut -d' ' -f3`
    echo "file $src_file says: SMP=$SMP"
  fi

  if [ "$SMP" = 0 ]; then
    echo "assuming default: SMP=$SMP"
  fi
  # act on final result
  if [ ! "$SMP" = 0 ]; then
    smp="-SMP"
    def_smp=-D__SMP__
  fi

}

setModVersions(){
  ! grep CONFIG_MODVERSIONS=y $kernelBuild/.config ||
  def_modversions="-DMODVERSIONS"
  # make.sh contains much more code to determine this whether its enabled
}

for src_file in \
  $kernelBuild/arch/x86/include/asm/compat.h \
  $linuxsources/arch/x86/include/asm/compat.h \
  $kernelBuild/include/asm-x86_64/compat.h \
  $linuxsources/include/asm-x86_64/compat.h \
  $kernelBuild/include/asm/compat.h;
  do
    if [ -e $src_file ];
      then
        break
    fi
done

if [ ! -e $src_file ]; then
    echo "Warning: x86 compat.h not found in kernel headers"
    echo "neither arch/x86/include/asm/compat.h nor include/asm-x86_64/compat.h"
    echo "could be found in $kernelBuild or $linuxsources"
    echo ""
  else
    if [ `cat $src_file | grep -c arch_compat_alloc_user_space` -gt 0 ]
       then
         COMPAT_ALLOC_USER_SPACE=arch_compat_alloc_user_space
    fi
    echo "file $src_file says: COMPAT_ALLOC_USER_SPACE=$COMPAT_ALLOC_USER_SPACE"
fi
# make.sh contains some code figuring out whether to use these or not..
PAGE_ATTR_FIX=0
setSMP
setModVersions
CC=gcc
MODULE=fglrx
LIBIP_PREFIX=$TMP/arch/$arch/lib/modules/fglrx/build_mod
[ -d $LIBIP_PREFIX ]
GCC_MAJOR="`gcc --version | grep -o -e ") ." | head -1 | cut -d " " -f 2`"
 # build .ko module
cd ./common/lib/modules/fglrx/build_mod/2.6.x
echo .lib${MODULE}_ip.a.GCC${GCC_MAJOR}.cmd
echo 'This is a dummy file created to suppress this warning: could not find /lib/modules/fglrx/build_mod/2.6.x/.libfglrx_ip.a.GCC4.cmd for /lib/modules/fglrx/build_mod/2.6.x/libfglrx_ip.a.GCC4' > lib${MODULE}_ip.a.GCC${GCC_MAJOR}.cmd
sed -i -e "s@COMPAT_ALLOC_USER_SPACE@$COMPAT_ALLOC_USER_SPACE@" ../kcl_ioctl.c
make CC=${CC} \
  LIBIP_PREFIX=$(echo "$LIBIP_PREFIX" | sed -e 's|^\([^/]\)|../\1|') \
  MODFLAGS="-DMODULE -DATI -DFGL -DPAGE_ATTR_FIX=$PAGE_ATTR_FIX -DCOMPAT_ALLOC_USER_SPACE=$COMPAT_ALLOC_USER_SPACE $def_smp $def_modversions" \
  KVER=$kernelVersion \
  KDIR=$kernelBuild \
  PAGE_ATTR_FIX=$PAGE_ATTR_FIX \
  -j4

cd $TMP
  # Install the kernel module
fglrxmod_dir=$out/lib/modules/${kernelVersion}/kernel/drivers/misc
mkdir -p $fglrxmod_dir
cp $TMP/common/lib/modules/fglrx/build_mod/2.6.x/fglrx.ko $fglrxmod_dir
