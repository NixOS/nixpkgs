{ autoreconfHook
, curl
, dbus
, fetchFromGitHub
, glib
, json-glib
, lib
, nix-update-script
, openssl
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "rauc";
  version = "1.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cst+hSMyuJw6b+ZA6XNVh0kVp7WUTiiXpO1TPeHA+sM=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ curl dbus glib json-glib openssl ];

  configureFlags = [
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-dbusinterfacesdir=${placeholder "out"}/share/dbus-1/interfaces"
    "--with-dbuspolicydir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-dbussystemservicedir=${placeholder "out"}/share/dbus-1/system-services"
  ];

  meta = with lib; {
    description = "Safe and secure software updates for embedded Linux";
    homepage = "https://rauc.io";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
