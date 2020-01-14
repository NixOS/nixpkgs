{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "05dh70967264lc3srwajnxxfdgsgybc9i7j2jqbqzin6dmxbnrc0";
  };

  modSha256 = "09ifp0iqd8jlz01mhxaz7adrcc699vim6pwxgf83pmqdw92jz034";

  subPackages = [ "cmd/reviewdog" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
