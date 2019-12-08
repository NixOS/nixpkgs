{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, stups-tokens
, stups-cli-support
, pytest
, pytestcov
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-zign";
  version = "1.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "zign";
    rev = version;
    sha256 = "1vk6pnprnd5lfx96hc2c1n7kwh99f260r730x4y2h7lamlv82fh4";
  };

  patches = [
    # pytest 5 is currently unsupported. Fetch and apply a pr that resolves this.
    (fetchpatch {
      url = https://github.com/zalando-stups/zign/commit/50140720211e547b0e59f7ddb39a732f0cc73ad7.patch;
      sha256 = "1zmyvg1z1asaqqsmxvsx0srvxd6gkgavppvg3dblxwhkml01awqk";
    })
  ];

  propagatedBuildInputs = [
    stups-tokens
    stups-cli-support
  ];

  preCheck = "
    export HOME=$TEMPDIR
  ";

  checkInputs = [
    pytest
    pytestcov
  ];

  meta = with lib; {
    description = "OAuth2 token management command line utility.";
    homepage = "https://github.com/zalando-stups/zign";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
