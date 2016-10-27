{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "shaarli-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/shaarli/Shaarli/releases/download/v0.8.0/shaarli-v0.8.0-full.tar.gz";
    sha256 = "04151fl62rs8vxsmdyq4qm8fi7fr7i6x0zhrg1zgssv8w8lfx1ww";
  };

  outputs = [ "out" "doc" ];

  patchPhase = ''
    substituteInPlace index.php \
      --replace "new ConfigManager();" "new ConfigManager(getenv('SHAARLI_CONFIG'));"
  '';

#    Point $SHAARLI_CONFIG to your configuration file, see https://github.com/shaarli/Shaarli/wiki/Shaarli-configuration.
#    For example:
#      <?php /*
#      {
#          "credentials": {
#              "login": "user",
#              "hash": "(password hash)",
#              "salt": "(password salt)"
#          },
#          "resource": {
#              "data_dir": "\/var\/lib\/shaarli",
#              "config": "\/var\/lib\/shaarli\/config.json.php",
#              "datastore": "\/var\/lib\/shaarli\/datastore.php",
#              "ban_file": "\/var\/lib\/shaarli\/ipbans.php",
#              "updates": "\/var\/lib\/shaarli\/updates.txt",
#              "log": "\/var\/lib\/shaarli\/log.txt",
#              "update_check": "\/var\/lib\/shaarli\/lastupdatecheck.txt",
#              "raintpl_tmp": "\/var\/lib\/shaarli\/tmp",
#              "thumbnails_cache": "\/var\/lib\/shaarli\/cache",
#              "page_cache": "\/var\/lib\/shaarli\/pagecache"
#          },
#          "updates": {
#              "check_updates": false
#          }
#      }
#      */ ?>

  installPhase = ''
    rm -r {cache,pagecache,tmp,data}/
    mv doc/ $doc/
    mkdir $out/
    cp -R ./* $out
  '';

  meta = with stdenv.lib; {
    description = "The personal, minimalist, super-fast, database free, bookmarking service";
    license = licenses.gpl3Plus;
    homepage = https://github.com/shaarli/Shaarli;
    maintainers = with maintainers; [ schneefux ];
    platforms = platforms.all;
  };
}
