{ stdenv
, lib
, fetchFromGitLab
, glib
, systemd
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "uresourced";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "benzea";
    repo = "uresourced";
    rev = "v${version}";
    sha256 = "QYvCqoFIlP/nLNp/cf4zPjMgPAsMc9nVegS36sMloqQ=";
  };

  patches = [
   ./0001-build-add-systemd-unit-dir-options.patch
   ./fix-paths.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    systemd
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dsysconfdir=/etc"
  ];

  meta = with lib; {
    description = "Dynamically allocate resources to the active user";
    homepage = "https://gitlab.freedesktop.org/benzea/uresourced";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
