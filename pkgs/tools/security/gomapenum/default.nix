{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomapenum";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "GoMapEnum";
    rev = "v${version}";
    sha256 = "sha256-6WZTmRse3mj1bimHE81JdSc4VKpMFbcJN3U4zgHMzJc=";
  };

  vendorSha256 = "sha256-Z/uLZIPKd75P9nI7kTFOwzWFkRTVwUojYEQms4OJ6Bk=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tools for user enumeration and password bruteforce";
    homepage = "https://github.com/nodauf/GoMapEnum";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
