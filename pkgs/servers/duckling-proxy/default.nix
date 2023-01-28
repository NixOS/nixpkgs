{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "duckling-proxy";
  version = "2021-07-23-unstable";

  src = fetchFromGitHub {
    owner = "LukeEmmet";
    repo = "duckling-proxy";
    rev = "e2bfd73a60d7afa43f13a9d420d514131fee8fd1";
    sha256 = "134hnfa4f5sb1z1j5684wmqzascsrlagx8z36i1470yggb00j4hr";
  };
  vendorSha256 = "0wxk1a5gn9a7q2kgq11a783rl5cziipzhndgp71i365y3p1ssqyf";

  meta = with lib; {
    description = "Gemini proxy to access the Small Web";
    homepage = "https://github.com/LukeEmmet/duckling-proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
