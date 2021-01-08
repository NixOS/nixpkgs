{ stdenv, fetchFromGitLab, writeText }:
let
  localConfig = writeText "config.local.php" ''
    <?php
      return require(getenv('JIRAFEAU_CONFIG'));
    ?>
  '';
in
stdenv.mkDerivation rec {
  pname = "jirafeau";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "mojo42";
    repo = "Jirafeau";
    rev = version;
    hash = "sha256-9v6rtxViXsolx5AKSp2HxcFyU1XJWFSiqzTBl+dQBD4=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    cp ${localConfig} $out/lib/config.local.php
  '';

  meta = with stdenv.lib; {
    description = "Website permitting upload of a file in a simple way and giving a unique link to it";
    license = licenses.agpl3;
    homepage = "https://gitlab.com/mojo42/Jirafeau";
    platforms = platforms.all;
    maintainers = with maintainers; [ davidtwco ];
  };
}
