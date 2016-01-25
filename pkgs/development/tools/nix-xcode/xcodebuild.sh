#!@shell@

echo >&2 "fake-xcodebuild: $@"

read -r -d '' versionFull <<'EOF'
MacOSX10.10.sdk - OS X 10.10 (macosx10.10)
SDKVersion: 10.10
Path: @sdk@/MacOSX10.10.sdk
PlatformVersion: 1.1
PlatformPath: @sdk@
ProductBuildVersion: 15E27c
ProductCopyright: 1983-2016 Apple Inc.
ProductName: Mac OS X
ProductUserVisibleVersion: 10.10.1
ProductVersion: 10.10.1
EOF

while (("$#")); do
  case "$1" in
    -sdk) shift;;

    -version)
      case "$2" in
        -*|"")
          echo "$versionFull"
          exit
          ;;
        *)
          echo "$versionFull" | grep "^$2" | cut -d: -f2 | cut -c2-
          exit
          ;;
      esac
      ;;
  esac
  shift
done
