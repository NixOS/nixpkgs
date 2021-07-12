{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "sigurlx";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "drsigned";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q5vy05387qx7h4xcccvn2z2ks1kiff3mfbd2w3w0l0a4qgz74xs";
  };

  vendorSha256 = "1bp6bf99rxlyg91pn1y228q18lawpykmvkl22cydmclms0q0n238";

  meta = with lib; {
    description = "Tool to map the attack surface of web applications";
    homepage = "https://github.com/drsigned/sigurlx";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
