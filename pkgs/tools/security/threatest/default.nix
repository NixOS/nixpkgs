{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "threatest";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xluKQXFa06ng9bs+sBkoFLeyYtQAcej4VFLMeTST6zA=";
  };

  vendorHash = "sha256-tvGmSpihGwpz6TCmbttz0VKvLTChDRWNX3qxOhEpdPM=";

  meta = with lib; {
    description = "Framework for end-to-end testing threat detection rules";
    homepage = "https://github.com/DataDog/threatest";
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
