{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "07h4ngn0ypjfhipb13lw56can6zcpiglzaqii1yy1avqwc4rjsln";
  };

  cargoSha256 = "12znw98jf1sy3iz6lrwdxya9rvwskc3yjkqir3xjfxw99w2jsiqb";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
