{ stdenv, xsel, curl, fetchFromGitLab, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "0x0";
  version = "2018-06-24";

  src = fetchFromGitLab {
    owner = "somasis";
    repo = "scripts";
    rev  = "70422c83b2ac5856559b0ddaf6e2dc3dbef40dee";
    sha256 = "1qpylyxrisy3p2lyirfarfj5yzrdjgsgxwf8gqwljpcjn207hr72";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 0x0 $out/bin/0x0

    patchShebangs $out/bin/0x0
    wrapProgram $out/bin/0x0 \
      --prefix PATH : '${stdenv.lib.makeBinPath [ curl xsel ]}'
  '';

  meta = with stdenv.lib; {
    description = "A client for 0x0.st";
    homepage = "https://gitlab.com/somasis/scripts/";
    maintainers = [ maintainers.ar1a ];
    license = licenses.unlicense;
  };
}
