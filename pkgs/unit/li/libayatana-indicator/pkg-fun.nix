{ stdenv, fetchFromGitHub, lib
, pkg-config, cmake
, gtk3
, ayatana-ido
}:

stdenv.mkDerivation rec {
  pname = "libayatana-indicator";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-indicator";
    rev = version;
    sha256 = "sha256-Bi+whbODdJMSQ6iiIrHAwht1Efi83icerT7ubQvE5n0=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ ayatana-ido ];

  meta = with lib; {
    description = "Ayatana Indicators Shared Library";
    homepage = "https://github.com/AyatanaIndicators/libayatana-indicator";
    changelog = "https://github.com/AyatanaIndicators/libayatana-indicator/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
