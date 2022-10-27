{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "git-hound";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "tillson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HD5OK8HjnLDbyC/TmVI2HfBRIUCyyHTbA3JvKoeXV5E=";
  };

  vendorSha256 = "sha256-qnIcjk2mzG/51ouhrAW6R3ZqoUSL6ZzYCOVZvKS7sBQ=";

  meta = with lib; {
    description = "Reconnaissance tool for GitHub code search";
    longDescription = ''
      GitHound pinpoints exposed API keys and other sensitive information
      across all of GitHub using pattern matching, commit history searching,
      and a unique result scoring system.
    '';
    homepage = "https://github.com/tillson/git-hound";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
