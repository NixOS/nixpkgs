{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zdzi98qywlwk5bp47963vya2p2ahrbjkc9h63lmb05wlas9s78y";
  };

  cargoSha256 = "0lvd5xpgh2vq2lszzb0fs6ha2vb419a5w0hlkq3287vq3ya3p4qg";

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
