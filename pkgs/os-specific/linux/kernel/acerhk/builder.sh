source $stdenv/setup

unpackPhase(){
  sourceRoot=.
}

buildPhase(){
    # it's not possible to unpack only one directory, is it ? :(
    # The linux folks should start using 7zip
    #unpackFile $kernel
    ln -s /tmp/linux-2.6.21.7/ .
    #mv linux* /tmp
    ensureDir orig/drivers/
    ensureDir patched/drivers/
    cp -r linux-*/drivers/misc orig/drivers
    cp -r linux-*/drivers/misc patched/drivers

    unpackFile $acerhk
    mv acerhk* patched/drivers/misc/acerhk
    if test -n debug; then
      sed -i -e 's/.*define ACERDEBUG.*/#define ACERDEBUG/' patched/drivers/misc/acerhk/acerhk.c
    fi

cat > ./sedscript  << EOF
/menu/a config ACERHK\\
       tristate "Acerhk driver"\\
       depends on EXPERIMENTAL\\
       default m\\
       ---help---\\
               This is an experimental acer keyboard driver for\\
               acer laptops\\
EOF
    sed -i -f ./sedscript patched/drivers/misc/Kconfig
    echo 'obj-$(CONFIG_ACERHK)   +=      acerhk/' >> patched/drivers/misc/Makefile
    
    set +e
    diff -urN orig patched > diff
    set -e
    ensureDir $out
    tar jcf ${out}/acerhk-patch.tar.bz2 diff
}


phases="buildPhase";
genericBuild
