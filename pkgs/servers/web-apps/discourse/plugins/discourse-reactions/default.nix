{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-reactions";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-reactions";
    rev = "3afaabc8e430dfe655be4efbbcb20ab7f0c7c8d3";
    sha256 = "sha256-CdrInrPFDpvYW7j0epIeAFUoPGTbmMOGdm2DpkIQBbs=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-reactions";
    maintainers = with maintainers; [ bbenno ];
    license = licenses.mit;
    description = "Allows users to react to a post from a choice of emojis, rather than only the like heart";
  };
}
