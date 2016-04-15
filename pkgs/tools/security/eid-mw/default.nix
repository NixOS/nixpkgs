{ stdenv, fetchFromGitHub, autoreconfHook, gtk3, nssTools, pcsclite
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "eid-mw-${version}";
  version = "4.1.14";

  src = fetchFromGitHub {
    sha256 = "1gj08dylcwdfjmdci1ja853n9xqkhgxy0x8m30bks81qwbnd12lp";
    rev = "v${version}";
    repo = "eid-mw";
    owner = "Fedict";
  };

  buildInputs = [ gtk3 pcsclite ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  postPatch = ''
    sed 's@m4_esyscmd_s(.*,@[${version}],@' -i configure.ac
  '';

  configureFlags = [ "--enable-dialogs=yes" ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    install -D ${./eid-nssdb.in} $out/bin/eid-nssdb
    substituteInPlace $out/bin/eid-nssdb \
      --replace "modutil" "${nssTools}/bin/modutil"

    # Only provides a useless "about-eid-mw.desktop" that segfaults anyway:
    rm -r $out/share/applications $out/bin/about-eid-mw
  '';

  meta = with stdenv.lib; {
    description = "Belgian electronic identity card (eID) middleware";
    homepage = http://eid.belgium.be/en/using_your_eid/installing_the_eid_software/linux/;
    license = licenses.lgpl3;
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
    platforms = platforms.linux;
  };
}
