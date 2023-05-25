{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "sdkman-for-fish";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "reitzig";
    repo = "sdkman-for-fish";
    rev = "v${version}";
    hash = "sha256-bfWQ2al0Xy8bnJt5euziHz/+qhyri4qWy47VDoPwQcg=";
  };

  meta = with lib; {
    description = "Adds support for SDKMAN! to fish";
    homepage = "https://github.com/reitzig/sdkman-for-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
