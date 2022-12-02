{ buildGoModule
, fetchFromGitHub
, lib, stdenv
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    rev = "v${version}";
    sha256 = "sha256-eXzD47qFkouYJkqWHbs2g2pbl3I7vWgIU6TqN3MEYQI=";
  };

  vendorSha256 = "sha256-tG+qV4Q77wT6x8y5cjZUaAWpL//sMUg1Ce3jS/dXF+Y=";

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
