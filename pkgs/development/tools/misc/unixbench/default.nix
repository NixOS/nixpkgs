{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, pandoc
, installShellFiles
, perl
, xorg
, libGLX
, coreutils
, unixtools
, targetPackages
, gnugrep
, gawk
, withGL? true
, withX11perf? true
}:

stdenv.mkDerivation rec {
  pname = "unixbench";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "kdlucas";
    repo = "byte-unixbench";
    rev = "a07fcc03264915c624f0e4818993c5b4df3fa703";
    hash = "sha256-gmRWAqE9/HBb0S9rK0DXoaCoiGbtat0gmdeozhbv0NI=";
  };

  patches = [
    ./common.patch
  ];

  patchFlags = [ "-p2" ];

  sourceRoot = "${src.name}/UnixBench";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Wa,-q" ""
  '';

  nativeBuildInputs = [
    makeWrapper
    pandoc
    installShellFiles
  ];

  buildInputs = [ perl ] ++ lib.optionals withGL [
    xorg.libX11
    xorg.libXext
    libGLX
  ];

  runtimeDependencies = [
    coreutils
    unixtools.nettools
    unixtools.locale
    targetPackages.stdenv.cc
    gnugrep
    gawk
  ] ++ lib.optionals withX11perf [
    xorg.x11perf
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ] ++ lib.optionals withGL [
    "GRAPHIC_TESTS=defined"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,libexec,share}
    install -D Run $out/bin/ubench
    cp -r pgms $out/libexec/
    cp -r testdir $out/share/
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace USAGE \
      --replace 'Run"' 'ubench"' \
      --replace './Run' 'ubench' \
      --replace 'Run ' 'ubench '
    pandoc -f rst -t man USAGE -o ubench.1
    installManPage ubench.1
  '';

  preFixup = ''
    substituteInPlace $out/libexec/pgms/multi.sh \
      --replace '/bin/sh "$' '${targetPackages.runtimeShell} "$'

    substituteInPlace $out/bin/ubench \
      --subst-var out

    wrapProgram $out/bin/ubench \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}
  '';

  meta = with lib; {
    description = "Basic indicator of the performance of a Unix-like system";
    homepage = "https://github.com/kdlucas/byte-unixbench";
    license = licenses.gpl2Plus;
    mainProgram = "ubench";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
