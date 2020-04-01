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
  version = "4.1.1";

  src = fetchFromGitLab {
    owner = "mojo42";
    repo = "Jirafeau";
    rev = "${version}";
    sha256 = "09gq5zhynygpqj0skq7ifnn9yjjg7qnc6kjvaas7f53av2707z4c";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    cp ${localConfig} $out/lib/config.local.php
  '';

  meta = with stdenv.lib; {
    description = "Jirafeau is a web site permitting to upload a file in a simple way and give an unique link to it.";
    license = licenses.agpl3;
    homepage = "https://gitlab.com/mojo42/Jirafeau";
    platforms = platforms.all;
    maintainers = with maintainers; [ davidtwco ];
  };
}
