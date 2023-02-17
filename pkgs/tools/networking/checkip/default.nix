{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.44.2";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jU0k6V3NoTdv/62VVa33WEo65eiYTCti0cWalsAiQwI=";
  };

  vendorSha256 = "sha256-lZZH9QyqPeO1m5UET9HUnxOzzz3M9y6QkL36T6BUia0=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
