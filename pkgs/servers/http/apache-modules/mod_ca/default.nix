{ stdenv, fetchurl, pkgconfig, apacheHttpd, openssl, openldap }:

stdenv.mkDerivation rec {
  pname = "mod_ca";
  version = "0.2.1";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "1pxapjrzdsk2s25vhgvf56fkakdqcbn9hjncwmqh0asl1pa25iic";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ apacheHttpd openssl openldap ];

  # Note that configureFlags and installFlags are inherited by
  # the various submodules.
  #
  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
  ];

  installFlags = [
    "INCLUDEDIR=${placeholder ''out''}/include"
    "LIBEXECDIR=${placeholder ''out''}/modules"
  ];

  meta = with stdenv.lib; {
    description = "RedWax CA service module";

    homepage = "https://redwax.eu";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
