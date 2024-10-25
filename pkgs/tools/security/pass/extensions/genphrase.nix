{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "pass-genphrase";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "congma";
    repo = "pass-genphrase";
    rev = version;
    sha256 = "01dff2jlp111y7vlmp1wbgijzphhlzc19m02fs8nzmn5vxyffanx";
  };

  dontBuild = true;

  buildInputs = [ python3 ];

  installTargets = [ "globalinstall" ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/genphrase.bash \
      --replace '$EXTENSIONS' "$out/lib/password-store/extensions/"
  '';

  meta = with lib; {
    description = "Pass extension that generates memorable passwords";
    homepage = "https://github.com/congma/pass-genphrase";
    license = licenses.gpl3;
    maintainers = with maintainers; [ seqizz ];
    platforms = platforms.unix;
  };
}
