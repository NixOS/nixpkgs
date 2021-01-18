{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "youtube_dlc";
  version = "2020.11.11.post3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "WqoKpfvVPZrN+pW6s8JoApJusn5CXyPcg9VcsY8R0FM=";
  };

  # They are broken
  doCheck = false;

  pythonImportsCheck = [ "youtube_dlc" ];

  meta = with lib; {
    homepage = "Media downloader supporting various sites such as youtube";
    description = "https://github.com/blackjack4494/yt-dlc";
    platforms = platforms.linux;
    maintainers = with maintainers; [ freezeboy ];
  };
}
