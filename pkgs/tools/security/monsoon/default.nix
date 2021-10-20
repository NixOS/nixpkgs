{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    rev = "v${version}";
    sha256 = "01c84s11m645mqaa2vdnbsj0kb842arqjhicgjv0ahb7qdw65zz4";
  };

  vendorSha256 = "1g84az07hv8w0jha2yl4f5jm0p9nkbawgw9l7cpmn8ckbfa54l7q";

  # tests fails on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Fast HTTP enumerator";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
