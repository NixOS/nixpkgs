#!@shell@
echo >&2 "fake-pkgutil: $@"

args=()

if [ "$1" = "--pkg-info" ]; then
  if [ "$2" = "com.apple.pkg.CLTools_Executables" ]; then
    cat <<EOF
package-id: com.apple.pkg.CLTools_Executables
version: 7.2.0.0.1.1447826929
volume: /
location: /
install-time: 1449620505
groups: com.apple.FindSystemFiles.pkg-group com.apple.DevToolsBoth.pkg-group com.apple.DevToolsNonRelocatableShared.pkg-group
EOF
  else
    echo >&2 "fake-pkgutil: --pkg-info for unknown package requested"
    exit 1
  fi
else
  echo >&2 "fake-pkgutil: unknown arguments"
  exit 1
fi
