{ buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "urlhunter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "utkusen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ph0pwfd8bb5499bsx3bd8sqhn69y00zk32ayc3n61gpcc6rmvn7";
  };

  vendorSha256 = "165kplaqigis0anafvzfqzwc3jjhsn2mwgf4phb4ck75n3yf85ys";

  meta = with stdenv.lib; {
    description = "Recon tool that allows searching shortened URLs";
    longDescription = ''
      urlhunter is a recon tool that allows searching on URLs that are
      exposed via shortener services such as bit.ly and goo.gl.
    '';
    homepage = "https://github.com/utkusen/urlhunter";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
