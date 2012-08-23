{ stdenv, gdb }:
stdenv.mkDerivation {
  name = "pstack-20120823";
  buildCommand = ''
    mkdir -p $out/bin
    cat > $out/bin/pstack <<EOF
    ${gdb}/bin/gdb -ex "set pagination 0" -ex "thread apply all bt" --batch -p \$1
    EOF
    chmod a+x $out/bin/pstack
  '';
}
