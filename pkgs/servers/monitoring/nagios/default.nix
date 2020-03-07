{ stdenv, fetchurl, perl, php, gd, libpng, zlib, unzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nagios";
  version = "4.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/nagios/nagios-4.x/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "079rgi3dqdg6h511c96hrch62rxsap9p4x37hm2nj672zb9f4sdz";
  };

  patches = [ ./nagios.patch ];
  buildInputs = [ php perl gd libpng zlib unzip ];

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
    homepage    = https://www.nagios.org/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice relrod ];
  };
}
