# To run these tests:
# nix-build -A tests.hooks

{ stdenv, pkgs, lib }:

{
  # this attrset is for hooks in `stdenv.defaultNativeBuildInputs`
  default-stdenv-hooks = lib.recurseIntoAttrs {
    make-symlinks-relative = stdenv.mkDerivation {
      name = "test-make-symlinks-relative";
      passAsFile = [ "buildCommand" ];
      buildCommand = ''
        mkdir -p $out/{bar,baz}
        source1="$out/bar/foo"
        destination1="$out/baz/foo"
        echo foo > $source1
        ln -s $source1 $destination1
        echo "symlink before patching: $(readlink $destination1)"

        _makeSymlinksRelative

        echo "symlink after patching: $(readlink $destination1)"
        ([[ -e $destination1 ]] && echo "symlink isn't broken") || (echo "symlink is broken" && exit 1)
        ([[ $(readlink $destination1) == "../bar/foo" ]] && echo "absolute symlink was made relative") || (echo "symlink was not made relative" && exit 1)
      '';
    };
  };
}
