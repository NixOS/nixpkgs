{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "prettyping";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "denilsonsa";
    repo = pname;
    rev = "v${version}";
    sha256 = "05vfaq9y52z40245j47yjk1xaiwrazv15sgjq64w91dfyahjffxf";
  };

  installPhase = ''
    install -Dt $out/bin prettyping
  '';

  meta = with lib; {
    homepage = "https://github.com/denilsonsa/prettyping";
    description = "Wrapper around the standard ping tool with the objective of making the output prettier, more colorful, more compact, and easier to read";
    mainProgram = "prettyping";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ qoelet ];
  };
}
