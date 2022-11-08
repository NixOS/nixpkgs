{ lib
, flutter2
, fetchFromGitHub
, stdenv
}:

flutter2.mkFlutterApp {
  pname = "firmware-updater";
  version = "unstable";

  vendorHash =
    if stdenv.system == "aarch64-linux"
    then "sha256-+ACmcIKXtGtaYBuwc7jY9hEdIS9qxQCbuxRKJQohX5A="
    else "sha256-nPblucEpNCBJYpIqx1My6SWq8CjXYuHDG/uphdcrWjQ=";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "a51817a2551e29895352618a91df9cf93d944af1";
    sha256 = "6uhks6a9JcyIC5o0VssqfBlE4pqKiQ7d3KOb6feNTvU=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Firmware Updater for Linux";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
