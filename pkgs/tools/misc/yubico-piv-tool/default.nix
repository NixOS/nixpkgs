{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, openssl
, check
, pcsclite
, PCSC
, gengetopt
, help2man
, cmake
, zlib
, withApplePCSC ? stdenv.isDarwin
, nix-update-script
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yubico-piv-tool";
  version = "2.4.1";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-piv-tool";
    rev = "refs/tags/yubico-piv-tool-${finalAttrs.version}";
    hash = "sha256-KprY5BX7Fi/qWRT1pda9g8fqnmDB1Bh7oFM7sCwViuw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    gengetopt
    help2man
  ];

  buildInputs = [
    openssl
    check
    zlib.dev
  ]
  ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  cmakeFlags = [
    "-DGENERATE_MAN_PAGES=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_MANDIR=share/man"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  configureFlags = [ "--with-backend=${if withApplePCSC then "macscard" else "pcsc"}" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "yubico-piv-tool-([0-9.]+)$" ];
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
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
    mainProgram = "yubico-piv-tool";
  };
})
