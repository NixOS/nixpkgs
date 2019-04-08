{ stdenv, pass, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pass-genphrase-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "congma";
    repo = "pass-genphrase";
    rev = "${version}";
    sha256 = "0vcg3b79n1r949qfn8ns85bq2mfsmbf4jw2dlzif8425n8ppfsgd";
  };

  dontBuild = true;

  installTargets = "globalinstall";

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
