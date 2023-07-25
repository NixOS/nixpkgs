{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "sshchecker";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "lazytools";
    repo = pname;
    rev = "v${version}";
    sha256 = "139b850h1w0392k8jcgj22jscsl2l60b5kk0n8378b6g57ikmis0";
  };

  vendorSha256 = "19hdaf7d6lvwrl5rc1srrjsjx57g25cy4lvw0vvs6j52impdk6ak";

  meta = with lib; {
    description = "Dedicated SSH brute-forcing tool";
    longDescription = ''
      sshchecker is a fast dedicated SSH brute-forcing tool to check
      SSH login on the giving IP list.
    '';
    homepage = "https://github.com/lazytools/sshchecker";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
