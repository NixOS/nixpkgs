{ stdenv, writeScriptBin, makeWrapper, lib, fetchurl, git, cacert, libpng, libjpeg, libwebp
, erlang, openssl, expat, libyaml, bash, gnused, gnugrep, coreutils, util-linux, procps, gd
, flock, autoreconfHook
, nixosTests
, withMysql ? false
, withPgsql ? false
, withSqlite ? false, sqlite
, withPam ? false, pam
, withZlib ? true, zlib
, withTools ? false
, withRedis ? false
}:

let
  ctlpath = lib.makeBinPath [ bash gnused gnugrep coreutils util-linux procps ];
in stdenv.mkDerivation rec {
  pname = "ejabberd";
  version = "23.01";

  nativeBuildInputs = [ makeWrapper autoreconfHook ];

  buildInputs = [ erlang openssl expat libyaml gd ]
    ++ lib.optional withSqlite sqlite
    ++ lib.optional withPam pam
    ++ lib.optional withZlib zlib
  ;

  src = fetchurl {
    url = "https://www.process-one.net/downloads/downloads-action.php?file=/${version}/ejabberd-${version}.tar.gz";
    sha256 = "sha256-K4P+A2u/Hbina4b3GP8T3wmPoQxiv88GuB4KZOb2+cA=";
  };

  passthru.tests = {
    inherit (nixosTests) ejabberd;
  };

  deps = stdenv.mkDerivation {
    pname = "ejabberd-deps";

    inherit src version;

    configureFlags = [ "--enable-all" "--with-sqlite3=${sqlite.dev}" ];

    nativeBuildInputs = [
      git erlang openssl expat libyaml sqlite pam zlib autoreconfHook
    ];

    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    makeFlags = [ "deps" ];

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

    dontPatchELF = true;
    dontStrip = true;
    # avoid /nix/store references in the source
    dontPatchShebangs = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Lj4YSPOiiJQ6uN4cAR+1s/eVSfoIsuvWR7gGkVYrOfc=";
  };

  configureFlags = [
    (lib.enableFeature withMysql "mysql")
    (lib.enableFeature withPgsql "pgsql")
    (lib.enableFeature withSqlite "sqlite")
    (lib.enableFeature withPam "pam")
    (lib.enableFeature withZlib "zlib")
    (lib.enableFeature withTools "tools")
    (lib.enableFeature withRedis "redis")
  ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite.dev}";

  enableParallelBuilding = true;

  postPatch = ''
    cp -r $deps deps
    chmod -R +w deps
    patchShebangs .
  '';

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e 's,\(^ *FLOCK=\).*,\1${flock}/bin/flock,' \
      -e 's,\(^ *JOT=\).*,\1,' \
      -e 's,\(^ *CONNLOCKDIR=\).*,\1/var/lock/ejabberdctl,' \
      $out/sbin/ejabberdctl
    wrapProgram $out/lib/eimp-*/priv/bin/eimp --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libpng libjpeg libwebp ]}"
    rm $out/bin/{mix,iex,elixir}
  '';

  meta = with lib; {
    description = "Open-source XMPP application server written in Erlang";
    license = licenses.gpl2;
    homepage = "https://www.ejabberd.im";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sander abbradar ];
  };
}
