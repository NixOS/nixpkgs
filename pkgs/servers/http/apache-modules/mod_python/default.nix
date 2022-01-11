{ lib, stdenv, fetchurl, apacheHttpd, python2, libintl }:

stdenv.mkDerivation rec {
  pname = "mod_python";
  version = "3.5.0";

  src = fetchurl {
    url = "http://dist.modpython.org/dist/${pname}-${version}.tgz";
    sha256 = "146apll3yfqk05s8fkf4acmxzqncl08bgn4rv0c1rd4qxmc91w0f";
  };

  patches = [ ./install.patch ];

  postPatch = ''
    substituteInPlace dist/version.sh \
        --replace 'GIT=`git describe --always`' "" \
        --replace '-$GIT' ""
  '';

  installFlags = [ "LIBEXECDIR=${placeholder "out"}/modules" ];

  preInstall = ''
    mkdir -p $out/modules $out/bin
  '';

  passthru = { inherit apacheHttpd; };

  buildInputs = [ apacheHttpd python2 ]
    ++ lib.optional stdenv.isDarwin libintl;

  meta = {
    homepage = "http://modpython.org/";
    description = "An Apache module that embeds the Python interpreter within the server";
    platforms = lib.platforms.unix;
  };
}
