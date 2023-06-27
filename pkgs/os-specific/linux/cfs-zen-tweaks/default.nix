{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, gawk
}:

stdenv.mkDerivation rec {
  pname = "cfs-zen-tweaks";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "igo95862";
    repo = "cfs-zen-tweaks";
    rev = version;
    sha256 = "HRR2tdjNmWyrpbcMlihSdb/7g/tHma3YyXogQpRCVyo=";
  };

  preConfigure = ''
    substituteInPlace set-cfs-zen-tweaks.bash \
      --replace '$(gawk' '$(${gawk}/bin/gawk'
  '';

  preFixup = ''
    chmod +x $out/lib/cfs-zen-tweaks/set-cfs-zen-tweaks.bash
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Tweak Linux CPU scheduler for desktop responsiveness";
    homepage = "https://github.com/igo95862/cfs-zen-tweaks";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
