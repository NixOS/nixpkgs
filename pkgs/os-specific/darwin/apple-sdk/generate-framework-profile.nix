{ runCommand }:

# In a normal programming language, one might store a hashmap
# { library name -> runtime dependencies }.
# associative arrays were only recently added to bash, and even then, bash arrays cannot
# be multidimensional. instead, the filesystem is the hash table!
# once every dependency in the tree has been visited, a comprehensive list of libraries
# will exist inside ./build. then `find ./build -type f` will give you the
# dependency tree you need!

frameworkName:

let path = "/System/Library/Frameworks/${frameworkName}.framework";

in runCommand "${frameworkName}-profile.sb" {
  # __noChroot lite
  __sandboxProfile = ''
    (allow file* (subpath "/"))
  '';

  # inconsistencies may exist between self and hydra
  allowSubstitutes = false;
} ''
  if [ ! -f "${path}/${frameworkName}" ]; then
    touch $out
    exit
  fi
  base=./build
  find_deps () {
    if [ -f "$base/$1" ]; then
      return
    fi
    dependencies=$(otool -l -arch x86_64 $1 \
      | grep 'LC_\w*_DYLIB' -A 2 \
      | grep name \
      | sed 's/^ *//' \
      | cut -d' ' -f2)
    mkdir -p $base/"$(dirname "$1")"
    touch $base/"$1"
    for dep in $dependencies; do
      find_deps "$dep"
    done
  }
  find_deps "${path}/${frameworkName}" "$out"
  set -o noglob
  profile="(allow file-read*"
  for file in $(find $base -type f); do
    filename=''${file/$base/}
    case $filename in
      /usr/lib/system*) ;;
      /usr/lib/libSystem.dylib) ;;
      /usr/lib/libSystem.B.dylib) ;;
      /usr/lib/libobjc.A.dylib) ;;
      /usr/lib/libobjc.dylib) ;;
      /usr/lib/libauto.dylib) ;;
      /usr/lib/libc++abi.dylib) ;;
      /usr/lib/libDiagnosticMessagesClient.dylib) ;;
      *) profile+=" (literal \"$filename\")" ;;
    esac
  done
  profile+=" (literal \"${path}/${frameworkName}\")"
  profile+=" (literal \"${path}/Versions/Current\")"
  echo "$profile)" > $out
''
