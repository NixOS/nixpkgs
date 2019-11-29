{ stdenv, fetchFromGitHub, makeWrapper, autoreconfHook, pkgconfig, wrapGAppsHook
, gtk2 ? null, gtk3 ? null, mednafen }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "mednaffe";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = "v${version}";
    sha256 = "13l7gls430dcslpan39k0ymdnib2v6crdsmn6bs9k9g30nfnqi6m";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk2 gtk3 mednafen ];

  configureFlags = [ (enableFeature (gtk3 != null) "gtk3") ];
  postInstall = "wrapProgram $out/bin/mednaffe --set PATH ${mednafen}/bin";

  meta = {
    description = "GTK-based frontend for mednafen emulator";
    homepage = https://github.com/AmatCoder/mednaffe;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sheenobu yegortimoshenko ];
    platforms = platforms.linux;
  };
}
