#! /bin/sh

IFS=

realgcc=@GCC@
libc=@LIBC@

justcompile=0
for i in $@; do
    if test "$i" == "-c"; then
        justcompile=1
    fi
    if test "$i" == "-S"; then
        justcompile=1
    fi
    if test "$i" == "-E"; then
        justcompile=1
    fi
done

IFS=" "
extra=$NIX_CFLAGS
if test "$justcompile" != "1"; then
    extra=(${extra[@]} $NIX_LDFLAGS)
fi

if test "$NIX_DEBUG" == "1"; then
  echo "extra gcc flags:"
  for i in ${extra[@]}; do
      echo "  $i"
  done
fi

IFS=
exec $realgcc $@ ${extra[@]}
