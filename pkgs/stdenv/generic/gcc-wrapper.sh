#! /bin/sh

IFS=

justcompile=0
for i in $@; do
    if test "$i" == "-c"; then
        justcompile=1
    elif test "$i" == "-S"; then
        justcompile=1
    elif test "$i" == "-E"; then
        justcompile=1
    elif test "$i" == "-E"; then
        justcompile=1
    elif test "$i" == "-M"; then
        justcompile=1
    elif test "$i" == "-MM"; then
        justcompile=1
    fi
done

IFS=" "
extra=($NIX_CFLAGS_COMPILE)
if test "$justcompile" != "1"; then
    extra=(${extra[@]} $NIX_CFLAGS_LINK)
    for i in $NIX_LDFLAGS; do
        extra=(${extra[@]} "-Wl,$i")
    done
    if test "$NIX_STRIP_DEBUG" == "1"; then
        extra=(${extra[@]} -g0 -Wl,-s)
    fi
fi

if test "$NIX_DEBUG" == "1"; then
  echo "extra flags to @GCC@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

IFS=
exec @GCC@ $@ ${extra[@]}
