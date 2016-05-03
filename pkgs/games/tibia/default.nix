{ stdenv, fetchurl, patchelf, glibc, libX11, mesa }:

with stdenv.lib;
assert stdenv.isi686;
stdenv.mkDerivation {
  name = "tibia-10.90";

  src = fetchurl {
    url = http://static.tibia.com/download/tibia1090.tgz;
    sha256 = "11mkh2dynmbpay51yfaxm5dmcys3rnpk579s9ypfkhblsrchbkhx";
  };

  shell = stdenv.shell;

  # These binaries come stripped already and trying to strip after the
  # files are in $out/res and after patchelf just breaks them.
  # Strangely it works if the files are in $out but then nix doesn't
  # put them in our PATH. We set all the files to $out/res because
  # we'll be using a wrapper to start the program which will go into
  # $out/bin.
  dontStrip = true;

  installPhase = ''
    mkdir -pv $out/res
    cp -r * $out/res

    patchelf --set-interpreter ${glibc.out}/lib/ld-linux.so.2 \
             --set-rpath ${stdenv.cc.cc.lib}/lib:${libX11}/lib:${mesa}/lib \
             "$out/res/Tibia"

    # We've patchelf'd the files. The main ‘Tibia’ binary is a bit
    # dumb so it looks for ‘./Tibia.dat’. This requires us to be in
    # the same directory as the file itself but that's very tedious,
    # especially with nix which changes store hashes. Here we generate
    # a simple wrapper that we put in $out/bin which will do the
    # directory changing for us.

    mkdir -pv $out/bin

    # The wrapper script itself. We use $LD_LIBRARY_PATH for libGL.
    cat << EOF > "$out/bin/Tibia"
    #!${stdenv.shell}
    cd $out/res
    ${glibc.out}/lib/ld-linux.so.2 --library-path \$LD_LIBRARY_PATH ./Tibia "\$@"
    EOF

    chmod +x $out/bin/Tibia

  '';

  meta = {
    description = "Top-down MMORPG set in a fantasy world";
    homepage = "http://tibia.com";
    license = stdenv.lib.licenses.unfree;
    platforms = ["i686-linux"];
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
