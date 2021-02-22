{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-audit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "v${version}";
    sha256 = "02iwjzaz2ks0zmwijaijwzc3gn9mhn7xpx369ylgaz68arlapfjg";
  };

  vendorSha256 = "11kb7xm82s0d8d06b2jknwn3dfh4i0a1dv0740y47vk62sf6f05i";

  # Tests need network access
  doCheck = false;

  meta = with lib; {
    description = "An alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
