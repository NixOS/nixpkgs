{ stdenv, lib, fetchFromGitHub, makeWrapper, unzip, catdoc }:

stdenv.mkDerivation {
  name = "catdocx-20170102";

  src = fetchFromGitHub {
    owner = "jncraton";
    repo = "catdocx";
    rev = "04fa0416ec1f116d4996685e219f0856d99767cb";
    sha256 = "1sxiqhkvdqn300ygfgxdry2dj2cqzjhkzw13c6349gg5vxfypcjh";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec $out/bin
    cp catdocx.sh $out/libexec
    chmod +x $out/libexec/catdocx.sh
    wrapProgram $out/libexec/catdocx.sh --prefix PATH : "${lib.makeBinPath [ unzip catdoc ]}"
    ln -s $out/libexec/catdocx.sh $out/bin/catdocx
  '';

  meta = with stdenv.lib; {
    description = "Extracts plain text from docx files";
    homepage = "https://github.com/jncraton/catdocx";
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.all;
  };
}
