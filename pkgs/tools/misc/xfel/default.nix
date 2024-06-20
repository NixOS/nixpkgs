{ fetchFromGitHub
, lib
, libusb1
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "xfel";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AvQORR9JPmahHv+pgQxr8Zm8DaaqwURqU746+Qs/Qz8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installPhase = ''
    runHook preInstall

    substituteInPlace 99-xfel.rules \
      --replace 'GROUP="users"' 'GROUP="felusers"' \
      --replace 'MODE="666"' 'MODE="660"'

    install -Dm755 xfel $out/bin/xfel
    install -Dm644 99-xfel.rules $out/lib/udev/rules.d/xfel.rules
    install -Dm644 LICENSE $out/share/licenses/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tooling for working with the FEL mode on Allwinner SoCs";
    homepage = "https://github.com/xboot/xfel";
    license = licenses.mit;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
