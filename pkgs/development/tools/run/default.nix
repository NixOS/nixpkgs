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

  modSha256 = "0s2lw9q5jskj41jqr8bv5w45pkrp2s0yfd2hgjgsd0q4ifm07k7s";

  meta = with stdenv.lib; {
    description = "Easily manage and invoke small scripts and wrappers";
    homepage    = https://github.com/TekWizely/run;
    license     = licenses.mit;
    maintainers = with maintainers; [ rawkode filalex77 ];
    platforms   = platforms.unix;
  };
}
