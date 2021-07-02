{ stdenv, lib, gettext, fetchFromGitLab }:

let
  awl = import ./awl.nix { inherit stdenv lib gettext fetchFromGitLab; };
in
stdenv.mkDerivation rec {
  version = "1.1.10";
  pname = "davical";

  inherit awl;

  src = fetchFromGitLab {
    owner = "davical-project";
    repo = "davical";
    rev = "r${version}";
    sha256 = "1mq9vs5mwa65shp8dxnpvgkdvlmwi2bglzfsgqqsdpxfnrjs024g";
  };

  # we patch so that the AWL utilities are found at the Nix location
  postPatch = ''
    sed "s|^awldirs=.*awl$|awldirs=\"${awl}/share/awl|g" -i dba/create-database.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/davical
    cp -r * $out/share/davical

    runHook postInstall
  '';

  buildInputs = [ gettext ];

  meta = with lib; {
    description = "A robust CalDAV and CardDAV server";
    license = licenses.gpl2Plus;
    homepage = "https://www.davical.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ henson ];
  };

}
