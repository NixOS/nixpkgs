{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docui";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "docui";
    rev = version;
    sha256 = "0jya0wdp8scjmsr44krdbbb8q4gplf44gsng1nyn12a6ldqzayxl";
  };

  modSha256 = "1wyx05kk4f41mgvwnvfc9xk7vd3x96cbn5xb5ph7p443f70ydnak";

  meta = with stdenv.lib; {
    description = "TUI Client for Docker";
    homepage = "https://github.com/skanehira/docui";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aethelz ];
  };
}
