{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  gitMinimal,
  mercurial,
  subversion,
  patchutils,
  less,
}:

buildPythonPackage rec {
  pname = "ydiff";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ii6EWI7zHT5SVwD6lksfmqth8MnEYoHgU0GlbgHc17g=";
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

  nativeCheckInputs = [ pygments ];

  checkPhase = ''
    runHook preCheck
    make reg # We don't want the linter or coverage check.
    runHook postCheck
  '';

  meta = with lib; {
    description = "View colored, incremental diff in workspace or from stdin with side by side and auto pager support (Was \"cdiff\")";
    mainProgram = "ydiff";
    longDescription = ''
      Term based tool to view colored, incremental diff in a version
      controlled workspace (supports Git, Mercurial, Perforce and Svn
      so far) or from stdin, with side by side (similar to diff -y)
      and auto pager support.
    '';
    homepage = "https://github.com/ymattw/ydiff";
    license = licenses.bsd3;
    maintainers = (with maintainers; [ leenaars ]) ++ teams.deshaw.members;
  };
}
