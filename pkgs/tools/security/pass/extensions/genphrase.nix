{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-genphrase";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "congma";
    repo = "pass-genphrase";
    rev = version;
    sha256 = "1sdkmz5s6wdx4vdlgqf5kmyrm17zwzy3n52s13qpx32bnnajap1h";
  };

  dontBuild = true;

  installTargets = [ "globalinstall" ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/genphrase.bash \
      --replace '$EXTENSIONS' "$out/lib/password-store/extensions/"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension that generates memorable passwords";
    homepage = https://github.com/congma/pass-genphrase;
    license = licenses.gpl3;
    maintainers = with maintainers; [ seqizz ];
    platforms = platforms.unix;
  };
}
