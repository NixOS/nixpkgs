{stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  version = "2.1.28";
  pname = "Tautulli";
  name = "${pname}-${version}";

  pythonPath = [ python.pkgs.setuptools ];
  buildInputs = [ python.pkgs.setuptools ];
  nativeBuildInputs = [ python.pkgs.wrapPython ];

  src = fetchFromGitHub {
    owner = "Tautulli";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yq2dqljfc7ci1n8c8szpylxcimhbfjr46m24hnsqp623w2gvm46";
  };

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp -R * $out/

    # Remove the PlexPy.py compatibility file as it won't work after wrapping.
    # We still have the plexpy executable in bin for compatibility.
    rm $out/PlexPy.py

    # Remove superfluous Python checks from main script;
    # prepend shebang
    echo "#!${python.interpreter}" > $out/Tautulli.py
    tail -n +7 Tautulli.py >> $out/Tautulli.py


    mkdir $out/bin
    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    echo "#!/bin/bash" > $out/bin/tautulli
    echo "$out/Tautulli.py \$*" >> $out/bin/tautulli
    chmod +x $out/bin/tautulli

    # Creat backwards compatibility symlink to bin/plexpy
    ln -s $out/bin/tautulli $out/bin/plexpy

    wrapPythonProgramsIn "$out" "$out $pythonPath"
  '';

  meta  = with stdenv.lib; {
    description = "A Python based monitoring and tracking tool for Plex Media Server.";
    homepage = https://tautulli.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ csingley ];
  };
}
