{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name    = "mq-cli-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "aprilabank";
    repo   = "mq-cli";
    rev    = "v${version}";
    sha256 = "02z85waj5jc312biv2qhbgplsggxgjmfmyv9v8b1ky0iq1mpxjw7";
  };

  cargoSha256 = "0kpv52474bp3k2wmz8xykca8iz46dwnjmly2nivblnaap49w2zsz";

  meta = with lib; {
    description      = "CLI tool to manage POSIX message queues";
    homepage         = "https://github.com/aprilabank/mq-cli";
    license          = licenses.mit;
    maintainers      = with maintainers; [ tazjin ];
    platforms        = platforms.linux;
    repositories.git = git://github.com/aprilabank/mq-cli.git;
  };
}
