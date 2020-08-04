{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "renderizer";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "gomatic";
    repo = pname;
    rev = version;
    sha256 = "1bip12pcn8bqgph7vd7bzzadwbyqh80fx7gqciv9fchycwsj04rf";
  };

  vendorSha256 = "13z357ww4j5bmmy8ag6d6gd5b2dib8kby73q8317pqnqzaxrrbcj";

  meta = with stdenv.lib; {
    description = "CLI to render Go template text files";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yurrriq ];
  };
}
