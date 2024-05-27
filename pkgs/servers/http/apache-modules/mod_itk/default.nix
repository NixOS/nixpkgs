{ lib
, stdenv
, fetchurl
, pkg-config
, mod_ca
, apr
, aprutil
, apacheHttpd
}:

stdenv.mkDerivation rec {
  pname = "mod_itk";
  version = "2.4.7-04";

  src = fetchurl {
    url = "http://mpm-itk.sesse.net/mpm-itk-${version}.tar.gz";
    sha256 = "sha256:1kzgd1332pgpxf489kr0vdwsaik0y8wp3q282d4wa5jlk7l877v0";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ mod_ca apr aprutil apacheHttpd ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/modules
    ${apacheHttpd.dev}/bin/apxs -S LIBEXECDIR=$out/modules -i mpm_itk.la

    runHook postInstall
  '';

  meta = with lib; {
    description = "an MPM (Multi-Processing Module) for the Apache web server.";
    maintainers = [ maintainers.zupo ];
    homepage = "http://mpm-itk.sesse.net/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
