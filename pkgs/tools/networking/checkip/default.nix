{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "065426z4iak72h56qvp1vk86r2vw5rdqy3qi1zbw1l0hnyq83zwq";
  };

  vendorSha256 = "10hk2wfkpvnavs20q390qgaj1gj10j1fy8vlqb9s9f76gpb130h4";

  postFixup = ''
    # Rename binary
    mv $out/bin/cmd $out/bin/${pname}
  '';

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
