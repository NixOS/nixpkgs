{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bypass403";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "drsigned";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x3a4lnxjxbv80kaydy57809n9r7vzci9ki4f98smf3w04s86rcl";
  };

  vendorSha256 = "1bp6bf99rxlyg91pn1y228q18lawpykmvkl22cydmclms0q0n238";

  meta = with lib; {
    description = "Tool to bypass 403 Forbidden responses";
    homepage = "https://github.com/drsigned/bypass403";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
