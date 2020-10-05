{ stdenv, fetchurl, makeWrapper, jre }:

let
  zshCompletion = version: fetchurl {
    url = "https://raw.githubusercontent.com/coursier/coursier/v${version}/modules/cli/src/main/resources/completions/zsh";
    sha256 = "1mn6cdmf59nkz5012wgd3gd6hpk2w4629sk8z95230ky8487dac3";
  };
in
stdenv.mkDerivation rec {
  pname = "coursier";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/releases/download/v${version}/coursier";
    sha256 = "07j113cszd4wggm8js4jl1lhg88mfs46nl2xf1733icz7p5rvjim";
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
