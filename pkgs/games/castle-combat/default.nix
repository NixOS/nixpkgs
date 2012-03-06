{ fetchurl, stdenv, buildPythonPackage, pygame, twisted, numeric, makeWrapper }:

buildPythonPackage rec {
  name = "castle-combat-0.8.1";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/castle-combat/${name}.tar.gz";
    sha256 = "1hp4y5dgj88j9g44h4dqiakrgj8lip1krlrdl2qpffin08agrvik";
  };

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs =
    [ pygame twisted

      # XXX: `Numeric.pth' should be found by Python but it's not.
      # Gobolinux has the same problem:
      # http://bugs.python.org/issue1431 .
      numeric
    ];

  patchPhase = ''
    sed -i "src/common.py" \
        -e "s|^data_path *=.*$|data_path = \"$out/share/${name}\"|g"

    mv -v "src/"*.py .
    sed -i "setup.py" -e's/"src"/""/g'
  '';

  postInstall = ''
    mkdir -p "$out/share/${name}"
    cp -rv "data/"* "$out/share/${name}"

    mv -v "$out/bin/castle-combat.py" "$out/bin/castle-combat"
  '';

  postPhases = "fixLoaderPath";

  fixLoaderPath =
    let dollar = "\$"; in
    '' sed -i "$out/bin/castle-combat" \
           -e "/^exec/ iexport LD_LIBRARY_PATH=\"$(cat ${stdenv.gcc}/nix-support/orig-gcc)/lib\:"'${dollar}'"LD_LIBRARY_PATH\"\\
export LD_LIBRARY_PATH=\"$(cat ${stdenv.gcc}/nix-support/orig-gcc)/lib64\:"'${dollar}'"LD_LIBRARY_PATH\""
    '';
      # ^
      # `--- The run-time says: "libgcc_s.so.1 must be installed for
      # pthread_cancel to work", which means it needs help to find it.

  # No test suite.
  doCheck = false;

  meta = {
    description = "Castle-Combat, a clone of the old arcade game Rampart";

    longDescription = ''
      Castle-Combat is a clone of the old arcade game Rampart.  Up to
      four players (or more in future versions) build castle walls,
      place cannons inside these walls, and shoot at the walls of
      their enemy(s).  If a player cannot build a complete wall around
      one of his castles, he loses.  The last surviving player wins.
    '';

    homepage = http://www.linux-games.com/castle-combat/;

    license = "unknown";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
