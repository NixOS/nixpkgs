{
  fetchurl,
  lib,
  stdenv,
  perl,
  makeWrapper,
  procps,
  coreutils,
  gawk,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "parallel";
  version = "20240922";

  src = fetchurl {
    url = "mirror://gnu/parallel/parallel-${version}.tar.bz2";
    hash = "sha256-YyEHFei3xeEp4JjzM8183V/HovMl6OD7ntbtup8ay8Q=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perl
    procps
  ];

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace Makefile.in \
      --replace '$(DESTDIR)$(bindir)/parallel --shell-completion' '${lib.getExe buildPackages.parallel} --shell-completion'
  '';

  preInstall = ''
    patchShebangs ./src/parallel
  '';

  postInstall = ''
    wrapProgram $out/bin/parallel \
      --prefix PATH : "${
        lib.makeBinPath [
          procps
          perl
          coreutils
          gawk
        ]
      }"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Shell tool for executing jobs in parallel";
    longDescription = ''
      GNU Parallel is a shell tool for executing jobs in parallel.  A job
      is typically a single command or a small script that has to be run
      for each of the lines in the input.  The typical input is a list of
      files, a list of hosts, a list of users, or a list of tables.

      If you use xargs today you will find GNU Parallel very easy to use.
      If you write loops in shell, you will find GNU Parallel may be able
      to replace most of the loops and make them run faster by running
      jobs in parallel.  If you use ppss or pexec you will find GNU
      Parallel will often make the command easier to read.

      GNU Parallel makes sure output from the commands is the same output
      as you would get had you run the commands sequentially.  This makes
      it possible to use output from GNU Parallel as input for other
      programs.
    '';
    homepage = "https://www.gnu.org/software/parallel/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      pSub
      tomberek
    ];
    mainProgram = "parallel";
  };
}
