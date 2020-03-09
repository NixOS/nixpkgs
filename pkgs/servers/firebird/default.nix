{stdenv, fetchurl, libedit, automake, autoconf, libtool
,
  # icu = null: use icu which comes with firebird

  # icu = pkgs.icu => you may have trouble sharing database files with windows
  # users if "Collation unicode" columns are being used
  # windows icu version is *30.dll, however neither the icu 3.0 nor the 3.6
  # sources look close to what ships with this package.
  # Thus I think its best to trust firebird devs and use their version

  # icu version missmatch may cause such error when selecting from a table:
  # "Collation unicode for character set utf8 is not installed"

  # icu 3.0 can still be built easily by nix (by dropping the #elif case and
  # make | make)
  icu ? null

, superServer ? false
, port ? 3050
, serviceName ? "gds_db"
}:

/*
   there are 3 ways to use firebird:
   a) superserver
    - one process, one thread for each connection
   b) classic
    - is built by default
    - one process for each connection
    - on linux direct io operations (?)
   c) embedded.

   manual says that you usually don't notice the difference between a and b.

   I'm only interested in the embedder shared libary for now.
   So everything isn't tested yet

*/

stdenv.mkDerivation rec {
  version = "2.5.7.27050-0";
  pname = "firebird";

  # enableParallelBuilding = false; build fails

  # http://tracker.firebirdsql.org/browse/CORE-3246
  preConfigure = ''
    makeFlags="$makeFlags CPU=$NIX_BUILD_CORES"
  '';

  configureFlags =
    [ "--with-serivec-port=${builtins.toString port}"
      "--with-service-name=${serviceName}"
      "--with-system-editline"
      "--with-fblog=/var/log/firebird"
      "--with-fbconf=/etc/firebird"
      "--with-fbsecure-db=/var/db/firebird/system"
    ]
    ++ (stdenv.lib.optional  (icu != null) "--with-system-icu")
    ++ (stdenv.lib.optional superServer "--enable-superserver");

  src = fetchurl {
    url = "mirror://sourceforge/firebird/Firebird-${version}.tar.bz2";
    sha256 = "06hp6bq5irqvm3h03s79qjgcc3jsjpq150y9aq7anklx9v4nhfqa";
  };

  hardeningDisable = [ "format" ];

  # configurePhase = ''
  #   sed -i 's@cp /usr/share/automake-.*@@' autogen.sh
  #   sh autogen.sh $configureFlags --prefix=$out
  # '';
  buildInputs = [libedit icu automake autoconf libtool];

  # TODO: Probably this hase to be tidied up..
  # make install requires beeing. disabling the root checks
  # dosen't work. Copying the files manually which can be found
  # in ubuntu -dev -classic, -example packages:
  # maybe some of those files can be removed again
  installPhase = ''cp -r gen/firebird $out'';

  meta = {
    description = "SQL relational database management system";
    homepage = https://www.firebirdnews.org;
    license = ["IDPL" "Interbase-1.0"];
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };

}
