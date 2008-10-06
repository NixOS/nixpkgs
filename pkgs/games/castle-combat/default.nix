{ fetchurl, stdenv, python, pygame, twisted, numeric, lib, makeWrapper }:

stdenv.mkDerivation rec {
  name = "castle-combat-0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/castle-combat/${name}.tar.gz";
    sha256 = "1hp4y5dgj88j9g44h4dqiakrgj8lip1krlrdl2qpffin08agrvik";
  };

  buildInputs = [ python pygame twisted makeWrapper ];

  patchPhase = ''
    sed -i "src/common.py" \
        -e "s|^data_path *=.*$|data_path = \"$out/share/${name}\"|g"
  '';

  buildPhase =   ''python setup.py build --build-base "$out"'';
  installPhase = ''
    python setup.py install --prefix "$out"

    ensureDir "$out/share/${name}"
    cp -rv data/* "$out/share/${name}"

    ${postInstall}
  '';

  postInstall = ''
    mv "$out/bin/castle-combat.py" "$out/bin/castle-combat"
    wrapProgram "$out/bin/castle-combat" \
      --prefix PYTHONPATH ":"          \
      ${lib.concatStringsSep ":"
         ([ "$out/lib/python2.5/site-packages/src"

            # XXX: `Numeric.pth' should be found by Python but it's not.
            # Gobolinux has the same problem:
            # http://bugs.python.org/issue1431 .
            "${numeric}/lib/python2.5/site-packages/Numeric" ] ++
          (map (path: path + "/lib/python2.5/site-packages")
               ([ "${pygame}" "${twisted}" ]
                ++ twisted.propagatedBuildInputs)))} \
      \
      --prefix LD_LIBRARY_PATH ":" \
               "$(cat ${stdenv.gcc}/nix-support/orig-gcc)/lib"

      # ^
      # `--- The run-time says: "libgcc_s.so.1 must be installed for
      # pthread_cancel to work", which means it need help to find it.

      rm -rf "$out/lib/src"
  '';

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
  };
}
