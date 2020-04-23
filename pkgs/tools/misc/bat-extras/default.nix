{ stdenv, fetchFromGitHub, bash, less, makeWrapper, ncurses, bat, ripgrep
, withShFmt ? true, shfmt
, withPrettier ? true, nodePackages
, withClangTools ? true, clang-tools
, withRustFmt ? true, rustfmt
, withEntr ? true, entr
}:

stdenv.mkDerivation rec {
  pname   = "bat-extras";
  version = "20200408";

  src = fetchFromGitHub {
    owner  = "eth-p";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "184d5rwasfpgbj2k98alg3wy8jmzna2dgfik98w2a297ky67s51v";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ bash makeWrapper ] ++ stdenv.lib.optional withShFmt shfmt;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    patchShebangs test.sh
    patchShebangs .test-framework/bin/best.sh

    chmod u+x .test-framework/lib/print_util.sh
    wrapProgram .test-framework/lib/print_util.sh \
      --prefix PATH : "${ncurses}/bin" \

    bash ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin

    substituteInPlace $out/bin/batgrep \
      --replace '$PAGER' '${less}/bin/less'

    substituteInPlace $out/bin/batwatch \
      --replace '$PAGER' '${less}/bin/less'

    wrapProgram $out/bin/batwatch \
      ${stdenv.lib.optionalString withEntr "--prefix PATH ':' '${entr}/bin'"}

    wrapProgram $out/bin/prettybat \
      ${stdenv.lib.optionalString withClangTools "--prefix PATH ':' '${clang-tools}/bin'"} \
      ${stdenv.lib.optionalString withPrettier "--prefix PATH ':' '${nodePackages.prettier}/bin'"} \
      ${stdenv.lib.optionalString withRustFmt "--prefix PATH ':' '${rustfmt}/bin'"} \
      ${stdenv.lib.optionalString withShFmt "--prefix PATH ':' '${shfmt}/bin'"}
  '';

  meta = with stdenv.lib; {
    description = "Bash scripts that integrate bat with various command line tools";
    homepage    = "https://github.com/eth-p/bat-extras";
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ bbigras ];
    platforms   = platforms.all;
  };
}
