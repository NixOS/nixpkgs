{ stdenv, writeScriptBin, makeWrapper, lib, fetchurl, git, cacert, libpng, libjpeg, libwebp
, erlang, openssl, expat, libyaml, bash, gnused, gnugrep, coreutils, util-linux, procps, gd
, flock
, withMysql ? false
, withPgsql ? false
, withSqlite ? false, sqlite
, withPam ? false, pam
, withZlib ? true, zlib
, withRiak ? false
, withElixir ? false, elixir
, withIconv ? true
, withTools ? false
, withRedis ? false
}:

let
  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      [ -r .rev ] && cat .rev || true
    fi
  '';

  ctlpath = lib.makeBinPath [ bash gnused gnugrep coreutils util-linux procps ];

in stdenv.mkDerivation rec {
  version = "20.03";
  pname = "ejabberd";

  src = fetchurl {
    url = "https://www.process-one.net/downloads/downloads-action.php?file=/${version}/${pname}-${version}.tgz";
    sha256 = "0i013l9cygmgainfid298n6llhs3mblfklry3jw2a6irvhffym0s";
  };

  nativeBuildInputs = [ fakegit ];

  buildInputs = [ erlang openssl expat libyaml gd makeWrapper ]
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withPam pam
    ++ lib.optional withZlib zlib
    ++ lib.optional withElixir elixir
    ;

  # Apparently needed for Elixir
  LANG = "en_US.UTF-8";

  deps = stdenv.mkDerivation {
    pname = "ejabberd-deps";
    inherit version;

    inherit src;

    configureFlags = [ "--enable-all" "--with-sqlite3=${sqlite.dev}" ];

    nativeBuildInputs = [ git erlang openssl expat libyaml sqlite pam zlib elixir ];

    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    makeFlags = [ "deps" ];

    phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" ];

    installPhase = ''
      for i in deps/*; do
        ( cd $i
          git reset --hard
          git clean -ffdx
          git describe --always --tags > .rev
          rm -rf .git
        )
      done
      rm deps/.got

      cp -r deps $out
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "0xwgi9hy6y0m8mwznl6px98kdmkcxg98k62zgqbaqd4paks5zwqa";
  };

  configureFlags =
    [ (lib.enableFeature withMysql "mysql")
      (lib.enableFeature withPgsql "pgsql")
      (lib.enableFeature withSqlite "sqlite")
      (lib.enableFeature withPam "pam")
      (lib.enableFeature withZlib "zlib")
      (lib.enableFeature withRiak "riak")
      (lib.enableFeature withElixir "elixir")
      (lib.enableFeature withIconv "iconv")
      (lib.enableFeature withTools "tools")
      (lib.enableFeature withRedis "redis")
    ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite.dev}";

  enableParallelBuilding = true;

  preBuild = ''
    cp -r $deps deps
    chmod -R +w deps
    patchShebangs deps
  '';

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e 's,\(^ *FLOCK=\).*,\1${flock}/bin/flock,' \
      -e 's,\(^ *JOT=\).*,\1,' \
      -e 's,\(^ *CONNLOCKDIR=\).*,\1/var/lock/ejabberdctl,' \
      $out/sbin/ejabberdctl
    wrapProgram $out/lib/eimp-*/priv/bin/eimp --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libpng libjpeg libwebp ]}"
  '';

  meta = with stdenv.lib; {
    description = "Open-source XMPP application server written in Erlang";
    license = licenses.gpl2;
    homepage = "https://www.ejabberd.im";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sander abbradar ajs124 ];
    broken = withElixir;
  };
}
