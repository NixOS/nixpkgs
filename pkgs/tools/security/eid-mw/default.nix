{ stdenv, fetchurl, gtk2, nssTools, pcsclite, pkgconfig }:

stdenv.mkDerivation rec {
  name = "${package}-${build}";
  package = "eid-mw-4.0.6-1620";
  build = "tcm406-258906";

  src = fetchurl {
    url = "http://eid.belgium.be/en/binaries/${package}.tar_${build}.gz";
    sha256 = "1ecb30f9f318bdb61a8d774fe76b948eb5841d4de6fee106029ed78daa7efbf2";
  };

  buildInputs = [ gtk2 pcsclite pkgconfig ];

  unpackPhase = "tar -xzf ${src} --strip-components=1";

  postInstall = ''
    install -D ${./eid-nssdb.in} $out/bin/eid-nssdb
    substituteInPlace $out/bin/eid-nssdb \
      --replace "modutil" "${nssTools}/bin/modutil"
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Belgian electronic identity card (eID) middleware";
    homepage = http://eid.belgium.be/en/using_your_eid/installing_the_eid_software/linux/;
    license = with licenses; lgpl3;
    longDescription = ''
      Allows user authentication and digital signatures with Belgian ID cards.
      Also requires a running pcscd service and compatible card reader.

      This package only installs the libraries. To use eIDs in NSS-compatible
      browsers like Chrom{e,ium} or Firefox, each user must first execute:

        ~$ eid-nssdb add

      (Running the script once as root with the --system option enables eID
      support for all users, but will *not* work when using Chrom{e,ium}!)

      Before uninstalling this package, it is a very good idea to run

        ~$ eid-nssdb [--system] remove

      and remove all ~/.pki and/or /etc/pki directories no longer needed.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
