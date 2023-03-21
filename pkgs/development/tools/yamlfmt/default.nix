{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oTdBFWISOfaz4ZDbJmyxtaKrjo9DVNJ5N7Qxnu7SwZA=";
  };

  vendorSha256 = "sha256-QRY6mYtrMvjUqXJOOvHL0b0OQ28320UwV8HL4fXpcNQ=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files.";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
  };
}
