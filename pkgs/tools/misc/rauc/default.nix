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
  version = "1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "10v9nllfw5y53797p00hk6645zkaa6cacsim1rh6y2jngnqfkmw0";
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
    "--with-dbusinterfacesdir=${placeholder "out"}/share/dbus-1/interfaces"
    "--with-dbuspolicydir=${placeholder "out"}/share/dbus-1/systemd.d"
    "--with-dbussystemservicedir=${placeholder "out"}/share/dbus-1/system-services"
  ];

  meta = with lib; {
    description = "Safe and secure software updates for embedded Linux";
    homepage = "https://rauc.io";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
