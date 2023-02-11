{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "peep";
  version = "0.1.4-post.2021-08-17";

  src = fetchFromGitHub {
    owner = "ryochack";
    repo = "peep";
    rev = "0eceafe16ff1f9c6d6784cca75b6f612c38901c4";
    sha256 = "sha256-HtyT9kFS7derPhiBzICHIz3AvYVcYpUj1OW+t5RivRs=";
  };

  cargoSha256 = "sha256-sHsmHCMuHc56Mkqk2NUtZgC0RGyqhPvW1fKHkEAhqYk=";

  meta = with lib; {
    description = "The CLI text viewer tool that works like less command on small pane within the terminal window";
    license = licenses.mit;
    homepage = "https://github.com/ryochack/peep";
    maintainers = with maintainers; [ ];
  };
}
