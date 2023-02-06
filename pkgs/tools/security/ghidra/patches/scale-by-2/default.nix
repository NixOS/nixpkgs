{ lib }:

# based on https://gist.github.com/nstarke/baa031e0cab64a608c9bd77d73c50fc6
{
  name = "ghidra-patch-scale-by-2";
  postPatch = ''
    replaceSymlinkWithFile() {
      if [ -L "$1" ]; then
        cp --remove-destination "$(readlink "$1")" "$1"
      fi
    }

    d=lib/ghidra/support
    cd $out/$d
    f=launch.properties
    s='VMARGS_LINUX=-Dsun.java2d.uiScale=2'
    if ! grep -q -x -F "$s" $f; then
      replaceSymlinkWithFile $f
      chmod +w $f
      printf "%s\n" "$s" >> $f
    fi
  '';
}
