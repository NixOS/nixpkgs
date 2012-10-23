# What is LIBGL_DRIVERS_PATH used for?
# TODO gentoo removes some tools because there are xorg sources (?)

source $stdenv/setup
set -x

die(){ echo $@; exit 1; }

# custom unpack:
unzip $src
run_file=$(echo amd-driver-installer-*)
sh $run_file --extract .


kernelVersion=$(cd ${kernel}/lib/modules && ls)
kernelBuild=$(echo ${kernel}/lib/modules/$kernelVersion/build)
linuxsources=$(echo ${kernel}/lib/modules/$kernelVersion/source)


# note: maybe the .config file should be used to determine this ?
# current kbuild infrastructure allows using CONFIG_* defines
# but ati sources don't use them yet..
# copy paste from make.sh
setSMP(){

  linuxincludes=$kernelBuild/include

  # copied and stripped. source: make.sh:

  # 3
  # linux/autoconf.h may contain this: #define CONFIG_SMP 1

  # Before 2.6.33 autoconf.h is under linux/.
  # For 2.6.33 and later autoconf.h is under generated/.
  if [ -f $linuxincludes/generated/autoconf.h ]; then
      autoconf_h=$linuxincludes/generated/autoconf.h
  else
      autoconf_h=$linuxincludes/linux/autoconf.h
  fi
  src_file=$autoconf_h

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
  ! grep CONFIG_MODVERSIONS=y $kernel/config ||
  def_modversions="-DMODVERSIONS"
  # make.sh contains much more code to determine this whether its enabled
}

# ==============================================================
# resolve if we are building for a kernel with a fix for CVE-2010-3081
# On kernels with the fix, use arch_compat_alloc_user_space instead
# of compat_alloc_user_space since the latter is GPL-only

COMPAT_ALLOC_USER_SPACE=arch_compat_alloc_user_space

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
if [ ! -e $src_file ];
then
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
case "$system" in
  x86_64-linux)
    arch=x86_64
    lib_arch=lib64
  ;;
  i686-linux)
    arch=x86
    lib_arch=lib
  ;;
  *) exit 1;;
esac
LIBIP_PREFIX=$TMP/arch/$arch/lib/modules/fglrx/build_mod
[ -d $LIBIP_PREFIX ]
GCC_MAJOR="`gcc --version | grep -o -e ") ." | head -1 | cut -d " " -f 2`"

{ # build .ko module
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
}

{ # install

  mkdir -p $out/lib/xorg

  cp -r common/usr/include $out
  cp -r common/usr/sbin $out
  cp -r common/usr/share $out
  cp -r common/usr/X11R6 $out

  # cp -r arch/$arch/lib $out/lib

  # what are those files used for?
  cp -r common/etc $out

  DIR_DEPENDING_ON_XORG_VERSION=xpic_64a
  cp -r $DIR_DEPENDING_ON_XORG_VERSION/usr/X11R6/$lib_arch/* $out/lib/xorg

  t=$out/lib/modules/${kernelVersion}/kernel/drivers/misc
  mkdir -p $t

  cp ./common/lib/modules/fglrx/build_mod/2.6.x/fglrx.ko $t

  # should this be installed at all?
  # its used by the example fglrx_gamma only
  # don't use $out/lib/modules/dri because this will cause the kernel module
  # aggregator code to see both: kernel version and the dri direcotry. It'll
  # fail saying different kernel versions
  cp -r $TMP/arch/$arch/usr/X11R6/$lib_arch/modules/dri $out/lib
  cp -r $TMP/arch/$arch/usr/X11R6/$lib_arch/modules/dri/* $out/lib
  cp -r $TMP/arch/$arch/usr/X11R6/$lib_arch/*.so.* $out/lib
  cp -r $TMP/arch/$arch/usr/X11R6/$lib_arch/fglrx/fglrx-libGL.so.1.2 $out/lib/fglrx-libGL.so.1.2

  cp -r $TMP/arch/$arch/usr/$lib_arch/* $out/lib

  # cp -r $TMP/arch/$arch/usr/$lib_arch/* $out/lib
  ln -s libatiuki.so.1.0 $out/lib/libatiuki.so.1
  ln -s fglrx-libGL.so.1.2 $out/lib/libGL.so.1
  ln -s fglrx-libGL.so.1.2 $out/lib/libGL.so

  ln -s libfglrx_gamma.so.1.0 $out/lib/libfglrx_gamma.so.1
  # make xorg use the ati version
  ln -s $out/lib/xorg/modules/extensions/{fglrx/fglrx-libglx.so,libglx.so}

}

{ # build samples
  mkdir -p $out/bin

  mkdir -p samples
  cd samples
  tar xfz ../common/usr/src/ati/fglrx_sample_source.tgz


  ( # build and install fgl_glxgears
    cd fgl_glxgears; 
    gcc -DGL_ARB_texture_multisample=1 -g \
    -I$mesa/include \
    -I$out/include \
    -L$mesa/lib -lGL -lGLU -lX11 -lm \
    -o $out/bin/fgl_glxgears -Wall  fgl_glxgears.c
  )

  true || ( # build and install

    # doesn't build  undefined reference to `FGLRX_X11SetGamma'
    # wich should be contained in -lfglrx_gamma

    cd programs/fglrx_gamma
    gcc -fPIC -I${libXxf86vm}/include \
	    -I${xf86vidmodeproto}/include \
	    -I$out/X11R6/include \
	    -L$out/lib \
	    -Wall -lm -lfglrx_gamma -lX11 -lXext -o fglrx_xgamma fglrx_xgamma.c 
  )

  { # copy binaries and wrap them:
    BIN=$TMP/arch/$arch/usr/X11R6/bin
    cp $BIN/* $out/bin
    for prog in $BIN/*; do
      patchelf --set-interpreter $(echo $glibc/lib/ld-linux*.so.2) $out/bin/$(basename $prog)
      wrapProgram $out/bin/$(basename $prog) --prefix LD_LIBRARY_PATH : $out/lib:$LD_LIBRARY_PATH
    done
  }

  rm -fr $out/lib/modules/fglrx # don't think those .a files are needed. They cause failure of the mod

}
