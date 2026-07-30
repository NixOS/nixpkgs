#!@bash@

if [ 1 = "$#" ] && [ "x-v" = "x$1" ]; then
  # HACK! should not pass -Wl if there are no input files, otherwise libtool breaks
  exec -a "@origname@" @gcc@ -v
fi

# logic based on pkgs/build-support/bintools-wrapper/ld-wrapper.sh
# very hacky
extraRpath=""
prev=""
for param in "$@"; do
  case "$prev" in
    -L | -B)
      case "$param" in
        "$NIX_STORE"*)
          extraRpath="$extraRpath -Wl,-rpath,${param}"
          ;;
        *)
          ;;
      esac
      ;;
    *)
      case "$param" in
        -L"$NIX_STORE"/* | -B"$NIX_STORE"/*)
          extraRpath="$extraRpath -Wl,-rpath,${param:2}"
          ;;
        "$NIX_STORE"/*.so | "$NIX_STORE"/*.so.*)
          extraRpath="$extraRpath -Wl,-rpath,${param%/*}"
          ;;
        *)
          ;;
      esac
      ;;
  esac
  prev="$param"
done

# Order of -B is very particular. musl detection in gnulib requires that
# libc/.. comes before libgcc, otherwise libc is assumed to be glibc.
# Also, libstdcxxinc uses #include_next directives that depend on
# libc headers, so libstdcxx must come before libc.
exec -a "@origname@" @gcc@ -Wl,-dynamic-linker=@dynlinker@ \
  @extraflags@ \
  $extraRpath \
  -Wl,-rpath,@libc@,-rpath,@libgcc@,-rpath,@libstdcxx@ \
  -I @libstdcxxarchinc@ \
  -I @libstdcxxinc@ \
  -B@libc@/.. \
  -B@libc@ \
  -B@libgcc@ \
  -B@origdir@ \
  -B@binutils@ \
  -B@libstdcxx@ \
  -isystem @gccinc@ \
  "$@"

