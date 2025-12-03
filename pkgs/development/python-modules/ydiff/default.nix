{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pygments,
  gitMinimal,
  mercurial,
  subversion,
  p4,
  less,
}:

buildPythonPackage rec {
  pname = "ydiff";
  version = "1.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ymattw";
    repo = "ydiff";
    tag = version;
    hash = "sha256-JaGkABroj+/7MrgpFYI2vE1bndsilIodopMUnfmNhwA=";
  };

  patchPhase = ''
    substituteInPlace ydiff.py \
      --replace-fail "['git'" "['${lib.getExe gitMinimal}'" \
      --replace-fail "['hg'" "['${lib.getExe mercurial}'" \
      --replace-fail "['svn'" "['${lib.getExe subversion}'" \
      --replace-fail "['p4'" "['${lib.getExe p4}'" \
      --replace-fail "['less'" "['${lib.getExe less}'" # doesn't support PAGER from env
    substituteInPlace tests/test_ydiff.py \
      --replace-fail /bin/rm rm \
      --replace-fail /bin/sh sh
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
    teams = [ teams.deshaw ];
  };
}
