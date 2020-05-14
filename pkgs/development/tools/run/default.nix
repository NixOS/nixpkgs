{ stdenv, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "run";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${version}";
    sha256 = "0q9f8lzrzybdablqph5wihqhfbfzb3bbnnxvhy7g5ccg1kzy7mgp";
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