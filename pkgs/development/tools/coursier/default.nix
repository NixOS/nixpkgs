{ stdenv, fetchurl, makeWrapper, jre }:

let
  zshCompletion = version: fetchurl {
    url = "https://raw.githubusercontent.com/coursier/coursier/v${version}/modules/cli/src/main/resources/completions/zsh";
    sha256 = "0afxzrk9w1qinfsz55jjrxydw0fcv6p722g1q955dl7f6xbab1jh";
  };
in
stdenv.mkDerivation rec {
  pname = "coursier";
  version = "2.0.5";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/releases/download/v${version}/coursier";
    sha256 = "1j614pw8i2mfgrv3jb5q3ifrxkrb7apj13zdrbnvnh4bzwlg5jb2";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm555 $src $out/bin/coursier
    patchShebangs $out/bin/coursier
    wrapProgram $out/bin/coursier --prefix PATH ":" ${jre}/bin

    # copy zsh completion
    install -Dm755 ${zshCompletion version} $out/share/zsh/site-functions/_coursier
  '';

  meta = with stdenv.lib; {
    homepage = "https://get-coursier.io/";
    description = "A Scala library to fetch dependencies from Maven / Ivy repositories";
    license = licenses.asl20;
    maintainers = with maintainers; [ adelbertc nequissimus ];
  };
}
