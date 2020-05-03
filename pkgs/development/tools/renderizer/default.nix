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

  modSha256 = "0ss5l2n1sl1i2hvxsdzy6p61mnnxmm6h256jvv0p0ajynx8g538q";

  meta = with stdenv.lib; {
    description = "CLI to render Go template text files";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yurrriq ];
  };
}
