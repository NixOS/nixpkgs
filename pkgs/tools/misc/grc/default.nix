{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "grc";
  version = "1.11.3";
  format = "other";

  src = fetchFromGitHub {
    owner  = "garabik";
    repo   = "grc";
    rev    = "v${version}";
    sha256 = "0b3wx9zr7l642hizk93ysbdss7rfymn22b2ykj4kpkf1agjkbv35";
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

  meta = with stdenv.lib; {
    description = "Yet another colouriser for beautifying your logfiles or output of commands";
    homepage    = http://korpus.juls.savba.sk/~garabik/software/grc.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 AndersonTorres peterhoeg ];
    platforms   = platforms.unix;

    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
  };
}
