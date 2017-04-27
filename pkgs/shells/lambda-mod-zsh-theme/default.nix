{ stdenv, fetchFromGitHub }:

let
  repo = "lambda-mod-zsh-theme";
  rev = "eceee68cf46bba9f7f42887c2128b48e8861e31b";
in stdenv.mkDerivation {
  name = "${repo}-${rev}";

  src = fetchFromGitHub {
    inherit rev repo;

    owner = "halfo";
    sha256 = "1410ryc22i20na5ypa1q6f106lkjj8n1qfjmb77q4rspi0ydaiy4";
  };

  buildPhases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp lambda-mod.zsh-theme $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A ZSH theme optimized for people who use Git & Unicode-compatible fonts and terminals";
    homepage = "https://github.com/halfo/lambda-mod-zsh-theme/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
