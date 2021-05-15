{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "corsmisc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "drsigned";
    repo = pname;
    rev = "v${version}";
    sha256 = "18a70v093jl85vnih80i50wvac8hsg3f2gmcws9jyhj2brndq2qj";
  };

  vendorSha256 = "1bp6bf99rxlyg91pn1y228q18lawpykmvkl22cydmclms0q0n238";

  meta = with lib; {
    description = "Tool to discover CORS misconfigurations vulnerabilities";
    homepage = "https://github.com/drsigned/corsmisc";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
