{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "the_platinum_searcher";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    rev = "v${version}";
    hash = "sha256-FNHlALFwMbajaHWOehdSFeQmvZSuCZLdqGqLZ7DF+pI=";
  };

  vendorHash = "sha256-GIjPgu0e+duN5MeWcRaF5xUFCkqe2aZJCwGbLUMko08=";

  patches = [
    # Add Go Modules support. See https://github.com/monochromegane/the_platinum_searcher/pull/217.
    (fetchpatch {
      url = "https://github.com/monochromegane/the_platinum_searcher/pull/217/commits/69064d11c57d5fd5f66ddd95f0e789786183d3c6.patch";
      hash = "sha256-qQ7kZYb2MWSUV6T1frIPT9nMfb20SI7lbG8YhqyQEi8=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/monochromegane/the_platinum_searcher";
    description = "A code search tool similar to ack and the_silver_searcher(ag)";
    mainProgram = "pt";
    license = licenses.mit;
  };
}
