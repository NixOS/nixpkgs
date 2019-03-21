{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "${program}-${version}";
  program = "prettyping";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "denilsonsa";
    repo = program;
    rev = "v${version}";
    sha256 = "05vfaq9y52z40245j47yjk1xaiwrazv15sgjq64w91dfyahjffxf";
  };

  installPhase = ''
    install -Dt $out/bin prettyping
  '';

  meta = with lib; {
    homepage = https://github.com/denilsonsa/prettyping;
    description = "A wrapper around the standard ping tool with the objective of making the output prettier, more colorful, more compact, and easier to read";
    license = with licenses; [ mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ qoelet ];
  };
}
