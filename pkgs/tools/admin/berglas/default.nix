{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {

  name = "berglas-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v0.5.0";
    sha256 = "1y5w2czipwj069w4zxnyb9xqv5mx0yjjramykf3vm3q478bk3rm7";
  };

  modSha256 = "0y4ajii3pv25s4gjazf6fl0b9wax17cmwhbmiybqhp61annca7kr";

  meta = with stdenv.lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = https://github.com/GoogleCloudPlatform/berglas;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
