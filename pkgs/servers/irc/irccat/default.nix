{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "irccat";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "irccloud";
    repo = "irccat";
    rev = "v${version}";
    sha256 = "sha256-fr5x1usviJPbc4t5SpIVgV9Q6071XG8eYtyeyraddts=";
  };

  vendorSha256 = "030hnkwh45yqppm96yy15j82skf7wmax5xkm7j5khr1l9lrz4591";

  meta = with lib; {
    homepage = "https://github.com/irccloud/irccat";
    description = "Send events to IRC channels from scripts and other applications";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl3Only;
  };
}
