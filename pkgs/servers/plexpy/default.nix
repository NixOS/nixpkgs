{stdenv, fetchFromGitHub, python}:

stdenv.mkDerivation rec {
  version = "1.4.25";
  pname = "plexpy";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "JonnyWong16";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a4ynrfamlwkgqil4n61v47p21czxpjdzg0mias4kdjam2nnwnjx";
  };

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp -R * $out/

    # Remove superfluous Python checks from main script;
    # prepend shebang
    echo "#!${python.interpreter}" > $out/PlexPy.py
    tail -n +7 PlexPy.py >> $out/PlexPy.py

    mkdir $out/bin
    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    echo "#!/bin/bash" > $out/bin/plexpy
    echo "$out/PlexPy.py \$*" >> $out/bin/plexpy
    chmod +x $out/bin/plexpy
  '';

  meta  = with stdenv.lib; {
    description = "A Python based monitoring and tracking tool for Plex Media Server.";
    homepage = http://jonnywong16.github.io/plexpy/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ csingley ];
  };
}
