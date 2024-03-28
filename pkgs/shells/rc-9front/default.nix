{ lib
, stdenv
, fetchFrom9Front
, unstableGitUpdater
, byacc
, coreutils
, installShellFiles

  # for tests only
, rc-9front
, runCommand
, nawk
}:

stdenv.mkDerivation {
  pname = "rc-9front";
  version = "unstable-2022-11-01";

  src = fetchFrom9Front {
    domain = "shithub.us";
    owner = "cinap_lenrek";
    repo = "rc";
    rev = "69041639483e16392e3013491fcb382efd2b9374";
    hash = "sha256-xc+EfC4bc9ZA97jCQ6CGCzeLGf+Hx3/syl090/x4ew4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ byacc installShellFiles ];
  enableParallelBuilding = true;
  patches = [ ./path.patch ];
  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    substituteInPlace ./rcmain.unix --replace COREUTILS ${coreutils}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ rc
    installManPage rc.1
    mkdir -p $out/lib
    install -m644 rcmain.unix $out/lib/rcmain

    runHook postInstall
  '';

  passthru = {
    shellPath = "/bin/rc";
    updateScript = unstableGitUpdater { shallowClone = false; };
    tests = {
      simple = runCommand "rc-test" { } ''
        ${rc-9front}/bin/rc -c 'nl=`{echo} && \
          res=`$nl{for(i in `{seq 1 10}) echo $i} && \
          echo -n $res' >$out
        [ "$(wc -l $out | ${nawk}/bin/nawk '{ print $1 }' )" = 10 ]
        [ "$(${nawk}/bin/nawk '{ a=a+$1 } END{ print a }' < $out)" = "$((10+9+8+7+6+5+4+3+2+1))" ]
      '';
      path = runCommand "rc-path" { } ''
        PATH='${coreutils}/bin:/a:/b:/c' ${rc-9front}/bin/rc -c 'echo $path(2-)' >$out
        [ '/a /b /c' = "$(cat $out)" ]
      '';
    };
  };

  meta = with lib; {
    description = "The 9front shell";
    longDescription = "unix port of 9front rc";
    homepage = "http://shithub.us/cinap_lenrek/rc/HEAD/info.html";
    license = licenses.mit;
    maintainers = with maintainers; [ moody ];
    mainProgram = "rc";
    platforms = platforms.all;
  };
}
