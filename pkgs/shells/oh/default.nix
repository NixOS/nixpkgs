{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "oh";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "michaelmacinnis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sdpk77i5mfamkdqldybl9znzz92hqgi4xvby5j28m0a5gw46kj0";
  };

  vendorSha256 = "12vlvh37hvi8c1i9arppm5wj4v9c98s7myxra10q6qpdqssgc8a0";

  meta = with lib; {
    homepage = "https://github.com/michaelmacinnis/oh";
    description = "A new Unix shell";
    license = licenses.mit;
  };

  passthru = {
    shellPath = "/bin/oh";
  };
}
