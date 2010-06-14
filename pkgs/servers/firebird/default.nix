{stdenv, fetchurl, libedit, icu
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

stdenv.mkDerivation {

  name = "firebird-2.3.1";

  configureFlags =
    [ "--with-serivec-port=${builtins.toString port}"
      "--with-service-name=${serviceName}"
      # "--with-system-icu"
      # "--with-system-editline"
    ]
    ++ (stdenv.lib.optional superServer "--enable-superserver=true");

  src = fetchurl {
    url = mirror://sourceforge/firebird/files/2.1.3-Release/Firebird-2.1.3.18185-0.tar.bz2;
    sha256 = "0a7xy016r0j1f97cf2lww8fkz1vlvvghrgv9ffz2i6f7ppacniw0";
  };

  buildInputs = [libedit icu];

  # TODO: Probably this hase to be tidied up..
  # make install requires beeing. disabling the root checks
  # dosen't work. Copying the files manually which can be found
  # in ubuntu -dev -classic, -example packages:
  # maybe some of those files can be removed again
  installPhase = ''cp -r gen/firebird $out'';

  meta = {
    description = "firebird database engine";
    homepage = http://www.firebirdnews.org;
    license = ["IDPL" "Interbase-1.0"];
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
