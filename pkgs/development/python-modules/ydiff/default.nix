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
<<<<<<< HEAD
  version = "1.5";
=======
  version = "1.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ymattw";
    repo = "ydiff";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-9a7M6+CqGRvO1yainImN2RQVH3XMxE9PTLXJGKekXLg=";
=======
    hash = "sha256-JaGkABroj+/7MrgpFYI2vE1bndsilIodopMUnfmNhwA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "View colored, incremental diff in workspace or from stdin with side by side and auto pager support (Was \"cdiff\")";
    mainProgram = "ydiff";
    longDescription = ''
      Term based tool to view colored, incremental diff in a version
      controlled workspace (supports Git, Mercurial, Perforce and Svn
      so far) or from stdin, with side by side (similar to diff -y)
      and auto pager support.
    '';
    homepage = "https://github.com/ymattw/ydiff";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    teams = [ lib.teams.deshaw ];
=======
    license = licenses.bsd3;
    teams = [ teams.deshaw ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
