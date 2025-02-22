{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  less,
  mercurial,
  patchutils,
  pygments,
  setuptools,
  subversion,
}:

buildPythonPackage rec {
  pname = "ydiff";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ymattw";
    repo = "ydiff";
    tag = "${version}";
    hash = "sha256-JaGkABroj+/7MrgpFYI2vE1bndsilIodopMUnfmNhwA=";
  };

  patchPhase = ''
    substituteInPlace ydiff.py \
      --replace "['git'" "['${gitMinimal}/bin/git'" \
      --replace "['hg'" "['${mercurial}/bin/hg'" \
      --replace "['svn'" "['${subversion}/bin/svn'" \
      --replace "['filterdiff'" "['${patchutils}/bin/filterdiff'" \
      --replace "['less'" "['${less}/bin/less'" # doesn't support PAGER from env
    substituteInPlace tests/test_ydiff.py \
      --replace /bin/rm rm \
      --replace /bin/sh sh
    patchShebangs setup.py
    patchShebangs tests/*.sh
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pygments ];

  checkPhase = ''
    runHook preCheck
    make reg # We don't want the linter or coverage check.
    runHook postCheck
  '';

  meta = with lib; {
    description = "View colored, incremental diff in workspace or from stdin with side by side and auto pager support (Was \"cdiff\")";
    longDescription = ''
      Term based tool to view colored, incremental diff in a version
      controlled workspace (supports Git, Mercurial, Perforce and Svn
      so far) or from stdin, with side by side (similar to diff -y)
      and auto pager support.
    '';
    homepage = "https://github.com/ymattw/ydiff";
    changelog = "https://github.com/ymattw/ydiff/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = (with maintainers; [ leenaars ]) ++ teams.deshaw.members;
    mainProgram = "ydiff";
  };
}
