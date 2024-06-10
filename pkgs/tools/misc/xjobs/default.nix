{ lib, stdenv, fetchurl
, flex, installShellFiles, ncurses, which
}:

stdenv.mkDerivation rec {
  pname = "xjobs";
  version = "20200726";

  src = fetchurl {
    url = "mirror://sourceforge//xjobs/files/${pname}-${version}.tgz";
    sha256 = "0ay6gn43pnm7r1jamwgpycl67bjg5n87ncl27jb01w2x6x70z0i3";
  };

  nativeBuildInputs = [
    flex
    installShellFiles
    which
  ];
  buildInputs = [
    ncurses
  ];

  checkPhase = ''
    runHook preCheck
    ./${pname} -V
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,etc}
    install -m755 ${pname} $out/bin/${pname}
    install -m644 ${pname}.rc $out/etc/${pname}.rc
    installManPage ${pname}.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Program which reads job descriptions line by line and executes them in parallel";
    homepage = "https://www.maier-komor.de/xjobs.html";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.siriobalmelli ];
    longDescription = ''
      xjobs reads job descriptions line by line and executes them in parallel.

      It limits the number of parallel executing jobs and starts new jobs when jobs finish.

      Therefore, it combines the arguments from every input line with the utility
      and arguments given on the command line.
      If no utility is given as an argument to xjobs,
      then the first argument on every job line will be used as utility.
      To execute utility xjobs searches the directories given in the PATH environment variable
      and uses the first file found in these directories.

      xjobs is most useful on multi-processor/core machines when one needs to execute
      several time consuming command several that could possibly be run in parallel.
      With xjobs this can be achieved easily, and it is possible to limit the load
      of the machine to a useful value.

      It works similar to xargs, but starts several processes simultaneously
      and gives only one line of arguments to each utility call.
    '';
    mainProgram = "xjobs";
  };
}
