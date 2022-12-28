{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mage";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "magefile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-77RjA5gncKE3fhejlmA+Vkhud4nyaRZW84I3cYTk0Js=";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [
    "-X github.com/magefile/mage/mage.commitHash=v${version}"
    "-X github.com/magefile/mage/mage.gitTag=v${version}"
    "-X github.com/magefile/mage/mage.timestamp=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "A Make/Rake-like Build Tool Using Go";
    homepage = "https://magefile.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop ];
  };
}
