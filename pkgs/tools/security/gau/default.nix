{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "gau";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1srbql603vvlxc6p1ibw0982icdq9kcr1iamxlr8bmgldbm8215w";
  };

  vendorSha256 = "17ag2wvaxv2dyx3yx3fvlf36ww4a44660pn4gvpbrwacsan9as5s";

  meta = with lib; {
    description = "Tool to fetch known URLs";
    longDescription = ''
      getallurls (gau) fetches known URLs from various sources for any
      given domain.
    '';
    homepage = "https://github.com/lc/gau";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
