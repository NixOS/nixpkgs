{ lib, writeShellScriptBin, steam-run, fetchurl }:
let

  pname = "itch-setup";
  version = "1.26.0";

  src = fetchurl {
    url = "https://broth.itch.ovh/itch-setup/linux-amd64/${version}/unpacked/default";
    hash = "sha256-bcJKqhgZK42Irx12BIvbTDMb/DHEOEXljetlDokF7x8=";
    executable = true;
  };

in
(writeShellScriptBin pname ''exec ${steam-run}/bin/steam-run ${src} "$@"'') // {

  passthru = { inherit pname version src; };
  meta = with lib; {
    description = "An installer for the itch.io desktop app";
    homepage = "https://github.com/itchio/itch-setup";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
