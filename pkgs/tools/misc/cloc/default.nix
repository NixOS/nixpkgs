{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
}:

let
  version = "2.00";
in
stdenv.mkDerivation {
  pname = "cloc";
  inherit version;

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${version}";
    sha256 = "sha256-GZvrsVuPLg09yOlDmdHNZ0QLXoftgSYMFkn6PLf1/Pw=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [
    perl
    AlgorithmDiff
    ParallelForkManager
    RegexpCommon
  ];

  makeFlags = [
    "prefix="
    "DESTDIR=$(out)"
    "INSTALL=install"
  ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo -n 'checking --version...'
    $out/bin/cloc --version | grep '${version}' > /dev/null
    echo ' ok'

    cat > test.nix <<EOF
    {a, b}: {
      test = a
        + b;
    }
    EOF

    echo -n 'checking lines in test.nix...'
    $out/bin/cloc --quiet --csv test.nix | grep '1,Nix,0,0,4' > /dev/null
    echo ' ok'

    runHook postInstallCheck
  '';

  meta = {
    description = "A program that counts lines of source code";
    homepage = "https://github.com/AlDanial/cloc";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rycee ];
    mainProgram = "cloc";
  };
}
