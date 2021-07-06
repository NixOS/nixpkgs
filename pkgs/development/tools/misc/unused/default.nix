{ lib, fetchFromGitHub, rustPlatform, cmake }:
rustPlatform.buildRustPackage rec {
  pname = "unused";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = pname;
    rev = version;
    sha256 = "0igpf0y45rrdrwq8bznq0d5nnph0vijvn6fw96mqxhbffz0csbi9";
  };

  nativeBuildInputs = [ cmake ];

  cargoSha256 = "1fngn9mmvx7jw8305w465z0nf9acc2cdl7314p77c2rz25z6rlin";

  meta = with lib; {
    description = "A tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = licenses.mit;
    maintainers = [ maintainers.lrworth ];
  };
}
