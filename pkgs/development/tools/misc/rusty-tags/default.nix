{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "rusty-tags-${version}";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "dan-t";
    repo = "rusty-tags";
    rev = "v${version}";
    sha256 = "1cv3cxjwlbc4rgkp19f8x28igs1xhjz2y05css19sarxbnzbkf34";
  };

  cargoSha256 = "1llnlr2i1xncwm55c5sg0h6fyv9991xh8iw8acyfgi5a79ylcpb6";

  meta = with lib; {
    description = "Create ctags/etags for a cargo project and all of its dependencies";
    homepage = https://github.com/dan-t/rusty-tags;
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ danielakhterov ];
    platforms = platforms.all;
  };
}
