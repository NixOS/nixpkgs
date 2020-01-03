{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docui";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "docui";
    rev = version;
    sha256 = "0rizl4rxmb3brzvqxw5llbgvq3rncix3h60pgq50djdf0jjnn5hs";
  };

  modSha256 = "0asqz9nnx80g2wi7dzxrfmppcraywrwdqi9vzr66vaihwpfpfnwz";

  meta = with stdenv.lib; {
    description = "TUI Client for Docker";
    homepage = https://github.com/skanehira/docui;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aethelz ];
  };
}
