{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ffuf";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TfPglATKQ3RIGODcIpSRL6FjbLyCjDzbi70jTLKYlLk=";
  };

  vendorHash = "sha256-nqv45e1W7MA8ElsJ7b4XWs26OicJ7IXmh93+wkueZg4=";

  meta = with lib; {
    description = "Fast web fuzzer written in Go";
    longDescription = ''
      FFUF, or “Fuzz Faster you Fool” is an open source web fuzzing tool,
      intended for discovering elements and content within web applications
      or web servers.
    '';
    homepage = "https://github.com/ffuf/ffuf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
