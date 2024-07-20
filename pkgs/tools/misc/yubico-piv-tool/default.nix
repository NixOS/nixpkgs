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
, nix-update-script
, testers
, withApplePCSC ? stdenv.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yubico-piv-tool";
  version = "2.5.2";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-piv-tool";
    rev = "refs/tags/yubico-piv-tool-${finalAttrs.version}";
    hash = "sha256-SBVYr6OcWqT+WKOZgIeZ1TmqCbcGAjbq/HaWIwPduFw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    gengetopt
    help2man
  ];

  buildInputs = [
    openssl
    zlib.dev
  ]
  ++ (if withApplePCSC then [ PCSC ] else [ pcsclite ]);

  cmakeFlags = [
    (lib.cmakeBool "GENERATE_MAN_PAGES" true)
    (lib.cmakeFeature "BACKEND" (if withApplePCSC then "macscard" else "pcsc"))
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_MANDIR" "share/man")
  ];

  doCheck = true;

  nativeCheckInputs = [ check ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "yubico-piv-tool-([0-9.]+)$" ];
    };
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "yubico-piv-tool --version";
      };
    };
  };

  meta = {
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
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ viraptor anthonyroussel ];
    mainProgram = "yubico-piv-tool";
    pkgConfigModules = [ "ykcs11" "ykpiv" ];
  };
})
