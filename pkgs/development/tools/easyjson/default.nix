{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easyjson";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${version}";
    sha256 = "0clifkvvy8f45rv3cdyv58dglzagyvfcqb63wl6rij30c5j2pzc1";
  };
  vendorHash = "sha256-L8u7QQPE2SnskcRrSIwQ4KhsX9xncqDWXJ75ytjxLJ4=";

  subPackages = [ "easyjson" ];

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
  };
}
