{ stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [ p.requests ]);

in stdenv.mkDerivation rec {
  pname = "pass-audit";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-audit";
    rev = "v${version}";
    sha256 = "0v0db8bzpcaa7zqz17syn3c78mgvw4mpg8qg1gh5rmbjsjfxw6sm";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ pythonEnv ];

  patchPhase = ''
    sed -i -e "s|/usr/lib|$out/lib|" audit.bash
    sed -i -e 's|$0|${pass}/bin/pass|' audit.bash
  '';

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    wrapProgram $out/lib/password-store/extensions/audit.bash \
      --prefix PATH : "${pythonEnv}/bin" \
      --run "export PREFIX"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension for auditing your password repository.";
    homepage = https://github.com/roddhjav/pass-audit;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
