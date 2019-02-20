{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, gtk3, nssTools, pcsclite
, libxml2, libproxy 
, openssl, curl
, makeWrapper
, substituteAll }:

stdenv.mkDerivation rec {
  name = "eid-mw-${version}";
  version = "4.4.13";

  src = fetchFromGitHub {
    sha256 = "14bgn2k0xbd6241qdghg787pgxy7k9rvcspaf74zwwyibaqknzyx"; 
    rev = "v${version}";
    repo = "eid-mw";
    owner = "Fedict";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = [ gtk3 pcsclite libxml2 libproxy curl openssl ];
  preConfigure = ''
    mkdir openssl
    ln -s ${openssl.out}/lib openssl
    ln -s ${openssl.bin}/bin openssl
    ln -s ${openssl.dev}/include openssl
    export SSL_PREFIX=$(realpath openssl)
    '';

  postPatch = ''
    sed 's@m4_esyscmd_s(.*,@[${version}],@' -i configure.ac
  '';

  configureFlags = [ "--enable-dialogs=yes" ];

  postInstall =
  let
    eid-nssdb-in = substituteAll {
      inherit (stdenv) shell;
      src = ./eid-nssdb.in;
    };
  in
  ''
    install -D ${eid-nssdb-in} $out/bin/eid-nssdb
    substituteInPlace $out/bin/eid-nssdb \
      --replace "modutil" "${nssTools}/bin/modutil"

    rm $out/bin/about-eid-mw
    wrapProgram $out/bin/eid-viewer --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/$name" 
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Belgian electronic identity card (eID) middleware";
    homepage = http://eid.belgium.be/en/using_your_eid/installing_the_eid_software/linux/;
    license = licenses.lgpl3;
    longDescription = ''
      Allows user authentication and digital signatures with Belgian ID cards.
      Also requires a running pcscd service and compatible card reader. 

      eid-viewer is also installed.

      **TO FIX:** 
      The procedure below did not work for me, I had to install the .so directly in firefox as instructed at
      https://eid.belgium.be/en/log-eid#7507
      and specify
      /run/current-system/sw/lib/libbeidpkcs11.so
      as the path to the module.

      This package only installs the libraries. To use eIDs in Firefox or
      Chromium, the eID Belgium add-on must be installed.
      This package only installs the libraries. To use eIDs in NSS-compatible
      browsers like Chrom{e,ium} or Firefox, each user must first execute:
        ~$ eid-nssdb add
      (Running the script once as root with the --system option enables eID
      support for all users, but will *not* work when using Chrom{e,ium}!)
      Before uninstalling this package, it is a very good idea to run
        ~$ eid-nssdb [--system] remove
      and remove all ~/.pki and/or /etc/pki directories no longer needed.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ bfortz ];
  };
}
