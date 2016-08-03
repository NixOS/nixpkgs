{ stdenv, lib, makeWrapper, retroarch, cores }:

let

  p = builtins.parseDrvName retroarch.name;

in

stdenv.mkDerivation {
  name = "retroarch-" + p.version;
  version = p.version;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/lib
    $(for coreDir in $cores
    do
      $(ln -s $coreDir/*.so $out/lib/.)
    done)

    ln -s -t $out ${retroarch}/share

    makeWrapper ${retroarch}/bin/retroarch $out/bin/retroarch \
      --suffix-each LD_LIBRARY_PATH ':' "$cores" \
      --add-flags "-L $out/lib/ --menu" \
  '';

  cores = map (x: x + x.libretroCore) cores;
  preferLocalBuild = true;

  meta = with retroarch.meta; {
    inherit license homepage platforms maintainers;
    description = description
                  + " (with cores: "
                  + lib.concatStrings (lib.intersperse ", " (map (x: ""+x.name) cores))
                  + ")";
  };
}
