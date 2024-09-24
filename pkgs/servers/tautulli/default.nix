{ lib, fetchFromGitHub, buildPythonApplication, setuptools, wrapPython, makeWrapper }:

buildPythonApplication rec {
  pname = "Tautulli";
  version = "2.14.4";
  format = "other";

  pythonPath = [ setuptools ];
  nativeBuildInputs = [ wrapPython makeWrapper ];

  src = fetchFromGitHub {
    owner = "Tautulli";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IV5ZyVuZvr09wQ8SgcHiTBp916B2ZPQvrg9+O8H3xsk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/tautulli
    cp -R contrib data lib plexpy Tautulli.py CHANGELOG.md $out/libexec/tautulli

    echo "master" > $out/libexec/tautulli/branch.txt
    echo "v${version}" > $out/libexec/tautulli/version.txt

    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    makeWrapper $out/libexec/tautulli/Tautulli.py $out/bin/tautulli
    wrapPythonProgramsIn "$out/libexec/tautulli" "$pythonPath"

    # Creat backwards compatibility symlink to bin/plexpy
    ln -s $out/bin/tautulli $out/bin/plexpy

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/tautulli --help

    runHook postCheck
  '';

  meta  = with lib; {
    description = "Python based monitoring and tracking tool for Plex Media Server";
    homepage = "https://tautulli.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
