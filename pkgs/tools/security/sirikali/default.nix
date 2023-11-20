{ lib
, stdenv
, qtbase
, libpwquality
, hicolor-icon-theme
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, pkg-config
, libgcrypt
, cryfs
, encfs
, fscrypt-experimental
, gocryptfs
, securefs
, sshfs
, libsecret
, kwallet
, withKWallet ? true
, withLibsecret ? true
}:

stdenv.mkDerivation rec {
  pname = "sirikali";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "sirikali";
    rev = version;
    hash = "sha256-1bY8cCMMK4Jie4+9c7eUEBrPEYDaOqFHZ5252TPSotA=";
  };

  buildInputs = [
    qtbase
    libpwquality
    hicolor-icon-theme
    libgcrypt
    cryfs
    encfs
    fscrypt-experimental
    gocryptfs
    securefs
    sshfs
  ]
  ++ lib.optionals withKWallet [ libsecret ]
  ++ lib.optionals withLibsecret [ kwallet ]
  ;

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    pkg-config
  ];

  qtWrapperArgs = [
    ''--prefix PATH : ${lib.makeBinPath [
      cryfs
      encfs
      fscrypt-experimental
      gocryptfs
      securefs
      sshfs
    ]}''
  ];

  postPatch = ''
    substituteInPlace "src/engines.cpp" --replace "/sbin/" "/run/wrappers/bin/"
  '';

  doCheck = true;

  cmakeFlags = [
    "-DINTERNAL_LXQT_WALLET=false"
    "-DNOKDESUPPORT=${if withKWallet then "false" else "true"}"
    "-DNOSECRETSUPPORT=${if withLibsecret then "false" else "true"}"
    "-DQT5=true"
  ];

  meta = with lib; {
    description = "A Qt/C++ GUI front end to sshfs, ecryptfs-simple, cryfs, gocryptfs, securefs, fscrypt and encfs";
    homepage = "https://github.com/mhogomchungu/sirikali";
    changelog = "https://github.com/mhogomchungu/sirikali/blob/${src.rev}/changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linuxissuper ];
  };
}
