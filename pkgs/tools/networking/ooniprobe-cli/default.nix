{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-06uUnxkkG6sfIfaXm5ZA4N3eWPeMZOyL740FqiKkHM4=";
  };

  vendorHash = "sha256-gjtrT1Dtk1sUTVK14qKtrIZNptj1mGNg6HTKv0HkEkc=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
