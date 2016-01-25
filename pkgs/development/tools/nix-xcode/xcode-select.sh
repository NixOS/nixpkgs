#!@shell@

echo >&2 "fake-xcode-select: $@"

case "$1" in
  --print-path)
    echo "@libc@"
    exit
    ;;
  *)
    echo >&2 "fake-xcode-select: unknown args"
    exit 1
    ;;
esac
