{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "curlie";
  version = "1.3.1";

  src= fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "09v8alrbw6qva3q3bcqxnyjm7svagfxqvhdff7cqf5pbmkxnhln9";
  };

  vendorSha256 = "1mxgf004czf65a2mv99gfp27g98xhllmfcz4ynfv66nfkbfz6a8n";

  meta = with lib; {
    description = "Curlie is a frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = "https://curlie.io/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
  };
}
