{ stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [ p.defusedxml ]);

in stdenv.mkDerivation rec {
  name = "pass-import-${version}";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-import";
    rev = "v${version}";
    sha256 = "1209aqkiqqbir5yzwk5jvyk8c1fyrsj9igr3n4banf347rlwmzfv";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ pythonEnv ];

  patchPhase = ''
    sed -i -e 's|$0|${pass}/bin/pass|' import.bash
  '';

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    wrapProgram $out/lib/password-store/extensions/import.bash \
      --prefix PATH : "${pythonEnv}/bin" \
      --run "export PREFIX"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension for importing data from existing password managers";
    homepage = https://github.com/roddhjav/pass-import;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 the-kenny fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
