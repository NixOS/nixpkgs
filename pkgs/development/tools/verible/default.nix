{ lib, stdenv, fetchFromGitHub, buildBazelPackage, flex, bison, python3 }:

buildBazelPackage rec {
  pname = "verible";
  version = "0.0-1789-g43d1b6fe";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "verible";
    rev = "v${version}";
    sha256 = "0szs1ld9rqibcjv7x0527c1fkbvm0i81jjkw7branq51z7ywgn4k";
  };

  nativeBuildInputs = [ flex bison python3 ];

  # These environment variables are read in the build process to skip
  # calling git extracting it from the repository.
  GIT_DATE = "2021-12-21";
  GIT_VERSION = "v${version}";

  bazelTarget = ":install-binaries";

  fetchAttrs = {
    sha256 = "01zhrdn1v41m9y0nbgs3hk8knq1kg3kchrdiwhkjz4718q5y4bvc";
  };

  buildAttrs = {
    installPhase = ''
      bazel run :install -c opt -- $out/bin
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/chipsalliance/verible";
    description = ''Suite of SystemVerilog developer tools, including a
                    style-linter, indexer, formatter, and language server.'';
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hzeller ];
  };
}
