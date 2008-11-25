{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "checkinstall-1.6.1";

  src = fetchurl {
    url = http://checkinstall.izto.org/files/source/checkinstall-1.6.1.tgz;
    sha256 = "0p6gbbnk4hjwkmv8dr7c4v5wpdnanczavi7yiiivvf45zyfl8lil";
  };

  buildInputs = [gettext];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out)

    substituteInPlace checkinstall --replace /usr/local/lib/checkinstall $out/lib/checkinstall
    substituteInPlace checkinstallrc-dist --replace /usr/local $out
  '';

  meta = {
    homepage = http://checkinstall.izto.org/;
    description = "A tool for automatically generating Slackware, RPM or Debian packages when doing `make install'";
  };
}
