{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "git-hound";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "tillson";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l2bif7qpc1yl93ih01g9jci7ba47rsnpq9js88rz216q93dzmsf";
  };

  vendorSha256 = "055hpfjbqng513c9rscb8jhnlxj7p82sr8cbsvwnzk569n71qwma";

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
