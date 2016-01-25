#!@shell@

echo >&2 "fake-xcrun: $@"

args=()

while (("$#")); do
  case "$1" in
    # glorified `which'
    -find)
      shift
      args+=(@which@/bin/which "$1")
      ;;

    # example: -sdk macosx
    # this argument is always useless to us
    -sdk) shift;;

    # bare arguments
    # example: xcrun clang -v
    *) args+=("$1");;
  esac
  shift
done

if [ "${#args[@]}" -gt "0" ]; then
  echo >&2 "fake-xcrun: executing ${args[@]}"
  exec "${args[@]}"
fi
