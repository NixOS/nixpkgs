{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.20.0";
  pname = "sqlite-jdbc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/xerial/${pname}/downloads/${name}.jar";
    sha256 = "0wxfxnq2ghiwy2mwz3rljgmy1lciafhrw80lprvqz6iw8l51qfql";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D "${src}" "$out/share/java/${name}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/xerial/sqlite-jdbc";
    description = "SQLite JDBC Driver";
    license = licenses.asl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}

