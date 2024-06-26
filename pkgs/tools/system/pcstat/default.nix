{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pcstat";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "tobert";
    repo = "pcstat";
    rev = "v${version}";
    sha256 = "sha256-e8fQZEfsS5dATPgshJktfKVTdZ9CvN1CttYipMjpGNM=";
  };

  vendorHash = "sha256-fdfiHTE8lySfyiKKiYJsQNCY6MBfjaVYSIZXtofIz3E=";

  meta = with lib; {
    description = "Page Cache stat: get page cache stats for files on Linux";
    homepage = "https://github.com/tobert/pcstat";
    license = licenses.asl20;
    maintainers = with maintainers; [ aminechikhaoui ];
    mainProgram = "pcstat";
  };
}
