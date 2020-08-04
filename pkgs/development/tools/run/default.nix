{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "run";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${version}";
    sha256 = "17n11lqhywq4z62w2rakdq80v7mxf83rgln19vj4v4nxpwd2hjjw";
  };

  vendorSha256 = "1g5rmiiwqpm8gky9yr5f2a7zsjjmm9i12r7yxj9cz7y3rmw9sw8c";

  meta = with stdenv.lib; {
    description = "Easily manage and invoke small scripts and wrappers";
    homepage    = "https://github.com/TekWizely/run";
    license     = licenses.mit;
    maintainers = with maintainers; [ rawkode filalex77 ];
    platforms   = platforms.unix;
  };
}
