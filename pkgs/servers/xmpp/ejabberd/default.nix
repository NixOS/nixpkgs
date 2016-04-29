{ stdenv, writeScriptBin, lib, fetchurl, fetchFromGitHub, git, cacert
, erlang, openssl, expat, libyaml, bash, gnused, gnugrep, coreutils, utillinux, procps
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

  ctlpath = lib.makeBinPath [ bash gnused gnugrep coreutils utillinux procps ];

in stdenv.mkDerivation rec {
  version = "16.04";
  name = "ejabberd-${version}";

  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "1hrcswk03x5x6f6xy8sac4ihhi6jcmsfp6449k3570j39vklz5ix";
  };

  nativeBuildInputs = [ fakegit ];

  buildInputs = [ erlang openssl expat libyaml ]
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withPam pam
    ++ lib.optional withZlib zlib
    ++ lib.optional withElixir elixir
    ;

  # Apparently needed for Elixir
  LANG = "en_US.UTF-8";

  deps = stdenv.mkDerivation {
    name = "ejabberd-deps-${version}";

    inherit src;

    configureFlags = [ "--enable-all" "--with-sqlite3=${sqlite}" ];

    buildInputs = [ git erlang openssl expat libyaml sqlite pam zlib elixir ];

    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    preBuild = ''
      patchShebangs .
    '';

    makeFlags = [ "deps" ];

    installPhase = ''
      for i in deps/*; do
        ( cd $i
          git reset --hard
          git clean -fdx
          git describe --always --tags > .rev
          rm -rf .git
        )
      done

      cp -r deps $out
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "0kmk22z1r9c23j9hh91975pqh3jkh7z6i1gnmw4qxr8alcnpr75f";
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
    ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite}";

  enableParallelBuilding = true;

  preBuild = ''
    cp -r $deps deps
    chmod -R +w deps

    for i in deps/*; do
      [ -x "$i/configure" ] && ( cd "$i"; ./configure ) || true
    done
  '';

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e 's,\(^ *FLOCK=\).*,\1${utillinux}/bin/flock,' \
      -e 's,\(^ *JOT=\).*,\1,' \
      -e 's,\(^ *CONNLOCKDIR=\).*,\1/var/lock/ejabberdctl,' \
      $out/sbin/ejabberdctl
  '';

  meta = {
    description = "Open-source XMPP application server written in Erlang";
    license = lib.licenses.gpl2;
    homepage = http://www.ejabberd.im;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sander lib.maintainers.abbradar ];
    broken = withElixir;
  };
}
