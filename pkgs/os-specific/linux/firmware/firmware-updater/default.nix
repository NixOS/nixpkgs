{ lib
, flutter2
, fetchFromGitHub
, stdenv
}:

flutter2.mkFlutterApp {
  pname = "firmware-updater";
  version = "unstable";

  vendorHash = {
    "x86_64-linux" = "sha256-xWP3SLq0IM1jcJ59OAEqRFMvnR2CphXwzq67iyyon1o=";
    "aarch64-linux" = "sha256-lymrdwzRdLm+b6pQ/iANJBL1ZQMJZnz8D36GtIdl9L8=";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

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
