{ lib, stdenv, fetchurl, perl, php, gd, libpng, zlib, unzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nagios";
  version = "4.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/nagios/nagios-4.x/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1x5hb97zbvkm73q53ydp1gwj8nnznm72q9c4rm6ny7phr995l3db";
  };

  patches = [ ./nagios.patch ];
  nativeBuildInputs = [ unzip ];
  buildInputs = [ php perl gd libpng zlib ];

  configureFlags = [ "--localstatedir=/var/lib/nagios" ];
  buildFlags = [ "all" ];

  # Do not create /var directories
  preInstall = ''
    substituteInPlace Makefile --replace '$(MAKE) install-basic' ""
  '';
  installTargets = "install install-config";
  postInstall = ''
    # don't make default files use hardcoded paths to commands
    sed -i 's@command_line *[^ ]*/\([^/]*\) @command_line \1 @'  $out/etc/objects/commands.cfg
    sed -i 's@/usr/bin/@@g' $out/etc/objects/commands.cfg
    sed -i 's@/bin/@@g' $out/etc/objects/commands.cfg
  '';

  passthru.tests = {
    inherit (nixosTests) nagios;
  };

  meta = {
    description = "A host, service and network monitoring program";
    homepage    = "https://www.nagios.org/";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ immae thoughtpolice relrod ];
  };
}
