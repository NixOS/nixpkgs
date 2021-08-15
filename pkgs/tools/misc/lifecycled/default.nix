{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "lifecycled";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "lifecycled";
    rev = "v${version}";
    sha256 = "sha256-+Ts2ERoEZcBdxMXQlxPVtQe3pst5NXWKU3rmS5CgR7A=";
  };

  vendorSha256 = "sha256-q5wYKSLHRzL+UGn29kr8+mUupOPR1zohTscbzjMRCS0=";

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute init/systemd/lifecycled.unit $out/lib/systemd/system/lifecycled.service \
      --replace /usr/bin/lifecycled $out/bin/lifecycled
  '';

  meta = with lib; {
    description = "A daemon for responding to AWS AutoScaling Lifecycle Hooks";
    homepage = "https://github.com/buildkite/lifecycled/";
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h grahamc ];
  };
}

