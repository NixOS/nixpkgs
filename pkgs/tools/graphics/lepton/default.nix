{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  glibc,
}:

stdenv.mkDerivation rec {
  version = "2019-08-20";
  pname = "lepton-unstable";

  src = fetchFromGitHub {
    repo = "lepton";
    owner = "dropbox";
    rev = "3d1bc19da9f13a6e817938afd0f61a81110be4da";
    sha256 = "0aqs6nvcbq8cbfv8699fa634bsz7csmk0169n069yvv17d1c07fd";
  };

  nativeBuildInputs = [
    cmake
    git
  ];
  buildInputs = lib.optionals stdenv.isLinux [ glibc.static ];

  meta = with lib; {
    homepage = "https://github.com/dropbox/lepton";
    description = "A tool to losslessly compress JPEGs";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [ artemist ];
    knownVulnerabilities = [ "CVE-2022-4104" ];
  };
}
