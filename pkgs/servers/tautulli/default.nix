{ lib, fetchFromGitHub, buildPythonApplication, setuptools, wrapPython, makeWrapper }:

buildPythonApplication rec {
  pname = "Tautulli";
  version = "2.7.6";
  format = "other";

  pythonPath = [ setuptools ];
  nativeBuildInputs = [ wrapPython makeWrapper ];

  src = fetchFromGitHub {
    owner = "Tautulli";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j57n8bi8qzzx1nw23rfr1g8yidg7p600pbbfv4b1dfiw8633jsl";
  };

  installPhase = ''
    mkdir -p $out/bin $out/libexec/tautulli
    cp -R contrib data lib plexpy Tautulli.py $out/libexec/tautulli

    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    makeWrapper $out/libexec/tautulli/Tautulli.py $out/bin/tautulli
    wrapPythonProgramsIn "$out/libexec/tautulli" "$pythonPath"

    # Creat backwards compatibility symlink to bin/plexpy
    ln -s $out/bin/tautulli $out/bin/plexpy
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/tautulli --help

    runHook postCheck
  '';

  meta  = with lib; {
    description = "A Python based monitoring and tracking tool for Plex Media Server";
    homepage = "https://tautulli.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ csingley ];
  };
}
