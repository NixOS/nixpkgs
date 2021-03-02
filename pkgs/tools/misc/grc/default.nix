{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "grc";
  version = "1.12";
  format = "other";

  src = fetchFromGitHub {
    owner  = "garabik";
    repo   = "grc";
    rev    = "v${version}";
    sha256 = "1020dfnb0fh7x9xfqgsxfjjryhwgfnq33bjfvn5lidq3mf7zb62w";
  };

  postPatch = ''
    for f in grc grcat; do
      substituteInPlace $f \
        --replace /usr/local/ $out/
    done
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh "$out" "$out"
    install -Dm444 -t $out/share/zsh/vendor-completions _grc

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another colouriser for beautifying your logfiles or output of commands";
    homepage    = "http://korpus.juls.savba.sk/~garabik/software/grc.html";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 AndersonTorres peterhoeg ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
