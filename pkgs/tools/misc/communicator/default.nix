{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, applet-window-buttons
, karchive
, kcoreaddons
, ki18n
, kio
, kirigami2
, mauikit
, mauikit-accounts
, mauikit-filebrowsing
, mauikit-texteditor
, qtmultimedia
, qtquickcontrols2
, kpeople
, kcontacts
}:

mkDerivation rec {
  pname = "communicator";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "communicator";
    rev = "v${version}";
    sha256 = "sha256-tHuFQgssZ6bohELx8tHrd4vvnrWixTyqCqK8WKJEdRE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/share/maui-accounts/manifests" "$out/usr/share/maui-accounts/manifests"
  '';

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-accounts
    mauikit-filebrowsing
    mauikit-texteditor
    qtmultimedia
    qtquickcontrols2
    kpeople
    kcontacts
  ];

  meta = with lib; {
    description = "Contacts and dialer application";
    homepage = "https://invent.kde.org/maui/communicator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
