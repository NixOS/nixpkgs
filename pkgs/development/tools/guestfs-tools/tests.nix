{ guestfs-tools
, libguestfs
, runCommand
}:

let
  inherit (guestfs-tools) pname version;
in
{
  version-tests = runCommand "${pname}-version-tests"
    {
      VERSION = version;
      GUESTFS_TOOLS = "${guestfs-tools}";
      LIBGUESTFS_PNAME = libguestfs.pname;
      LIBGUESTFS_VERSION = libguestfs.version;

      meta.timeout = 60;
    } ''
    for bin in "$GUESTFS_TOOLS"/bin/*; do
      expected="''${bin##*/} $VERSION"
      case "''${bin##*/}" in
      virt-win-reg) expected="$(printf '%s\n%s %s' "$expected" "$LIBGUESTFS_PNAME" "$LIBGUESTFS_VERSION")" ;;
      esac
      actual="$("$bin" --version)"
      if [ "$actual" != "$expected" ]; then
        echo Error: program version does not match package version >&2
        echo Expected: "$expected" >&2
        echo Actual: "$actual" >&2
        exit 1
      fi
    done

    touch -- "$out"
  '';
}
