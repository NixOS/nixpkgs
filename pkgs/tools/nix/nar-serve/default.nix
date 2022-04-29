{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "nar-serve";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${version}";
    hash = "sha256-h/pzKRXgcGTpr1YUKppDa+iTLKak/PGhbYa8ZczWj1U=";
  };

  vendorSha256 = "sha256-eW+cul/5qJocpKV/6azxj7HTmkezDw6dNubPtAOP5HU=";

  doCheck = false;

  meta = with lib; {
    description = "Serve NAR file contents via HTTP";
    homepage = "https://github.com/numtide/nar-serve";
    license = licenses.mit;
    maintainers = with maintainers; [ rizary ];
  };
}
