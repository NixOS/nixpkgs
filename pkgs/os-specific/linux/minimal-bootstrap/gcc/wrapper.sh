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
        /nix/store/*)
          extraRpath="$extraRpath -Wl,-rpath,${param}"
          ;;
        *)
          ;;
      esac
      ;;
    *)
      case "$param" in
        -L/nix/store/* | -B/nix/store/*)
          extraRpath="$extraRpath -Wl,-rpath,${param:2}"
          ;;
        /nix/store/*.so | /nix/store/*.so.*)
          extraRpath="$extraRpath -Wl,-rpath,${param%/*}"
          ;;
        *)
          ;;
      esac
      ;;
  esac
  prev="$param"
done

exec -a "@origname@" @gcc@ -Wl,-dynamic-linker=@dynlinker@ \
  @extraflags@ \
  $extraRpath \
  -Wl,-rpath,@libc@,-rpath,@libgcc@ \
  -B@libgcc@ \
  -B@libc@ \
  -B@origdir@ \
  -B@binutils@ \
  -isystem @gccinc@ \
  "$@"
