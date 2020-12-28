{ stdenv, fetchFromGitHub, cmake, boost, eigen, xz, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "kenlm-unstable";
  version = "2020-11-03";

  src = fetchFromGitHub {
    owner = "kpu";
    repo = "kenlm";
    rev = "d70e28403f07e88b276c6bd9f162d2a428530f2e";
    sha256 = "1ia9mj1cqd4bg6311fpay05awnx8kmmqb53jwq9yhv7kcvsa6yay";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost eigen xz zlib bzip2 ];

  meta = with stdenv.lib; {
    description = "Faster and Smaller Language Model Queries";
    longDescription = ''
      KenLM estimates, filters, and queries language models.

      Estimation is fast and scalable due to streaming algorithms explained in the paper:

      Scalable Modified Kneser-Ney Language Model Estimation
      Kenneth Heafield, Ivan Pouzyrevsky, Jonathan H. Clark, and Philipp Koehn. ACL, Sofia, Bulgaria, 4—9 August, 2013.

      Querying is fast and low-memory, as shown in the paper:

      KenLM: Faster and Smaller Language Model Queries
      Kenneth Heafield. WMT at EMNLP, Edinburgh, Scotland, United Kingdom, 30—31 July, 2011.
    '';
    homepage = "https://kheafield.com/code/kenlm/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ znewman01 ];
  };
}
