{ lib
, flutter
, fetchFromGitHub
}:

flutter.mkFlutterApp {
  pname = "firmware-updater";
  version = "unstable";

  vendorHash = "sha256-QgeRCFbd3AcFekJunFTwu2nDOQpAOMJUxZhgY4stJJc=";

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
    license = licenses.free;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
