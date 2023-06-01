{ lib
, stdenv
, fetchurl
, pkg-config
, openssl
, check
, pcsclite
, PCSC
, gengetopt
, cmake
, withApplePCSC ? stdenv.isDarwin
, gitUpdater
, testers
, yubico-piv-tool
}:

stdenv.mkDerivation rec {
  pname = "yubico-piv-tool";
  version = "2.3.1";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-${version}.tar.gz";
    hash = "sha256-2ona/YthhapjU0Z1P53bKa8pvEq9kt2B832dZWC11k4=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [ pkg-config cmake gengetopt ];
  buildInputs = [ openssl check ]
    ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  cmakeFlags = [
    "-DGENERATE_MAN_PAGES=OFF" # Use the man page generated at release time
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_MANDIR=share/man"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  configureFlags = [ "--with-backend=${if withApplePCSC then "macscard" else "pcsc"}" ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://github.com/Yubico/yubico-piv-tool.git";
      rev-prefix = "yubico-piv-tool-";
    };
    tests.version = testers.testVersion {
      inherit version;
      package = yubico-piv-tool;
      command = "yubico-piv-tool --version";
    };
  };

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubico-piv-tool/";
    changelog = "https://developers.yubico.com/yubico-piv-tool/Release_Notes.html";
    description = ''
      Used for interacting with the Privilege and Identification Card (PIV)
      application on a YubiKey
    '';
    longDescription = ''
      The Yubico PIV tool is used for interacting with the Privilege and
      Identification Card (PIV) application on a YubiKey.
      With it you may generate keys on the device, importing keys and
      certificates, and create certificate requests, and other operations.
      A shared library and a command-line tool is included.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ viraptor anthonyroussel ];
  };
}
