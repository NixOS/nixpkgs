{ stdenv, fetchFromGitHub, makeWrapper, autoreconfHook, pkgconfig, wrapGAppsHook
, gtk2 ? null, gtk3 ? null, mednafen }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mednaffe";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = "${version}";
    sha256 = "15qk3a3l1phr8bap2ayh3c0vyvw2jwhny1iz1ajq2adyjpm9fhr7";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk2 gtk3 mednafen ];

  configureFlags = [ (enableFeature (gtk3 != null) "gtk3") ];
  postInstall = "wrapProgram $out/bin/mednaffe --set PATH ${mednafen}/bin";

  meta = {
    description = "GTK-based frontend for mednafen emulator";
    homepage = "https://github.com/AmatCoder/mednaffe";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sheenobu yegortimoshenko AndersonTorres ];
    platforms = platforms.linux;
  };
}
