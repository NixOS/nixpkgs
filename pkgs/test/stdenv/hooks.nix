{ stdenv }:

# ordering should match defaultNativeBuildInputs

{
  move-docs = stdenv.mkDerivation {
    name = "test-move-docs";
    buildCommand = ''
      mkdir -p $out/{man,doc,info}
      touch $out/{man,doc,info}/foo
      cat $out/{man,doc,info}/foo

      _moveToShare

      (cat $out/share/{man,doc,info}/foo 2>/dev/null && echo "man,doc,info were moved") || (echo "man,doc,info were not moved" && exit 1)
    '';
  };
  make-symlinks-relative = stdenv.mkDerivation {
    name = "test-make-symlinks-relative";
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
}
