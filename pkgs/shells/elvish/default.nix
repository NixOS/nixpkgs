{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "0.16.1";

  excludedPackages = [ "website" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/elves/elvish/pkg/buildinfo.Version==${version} -X github.com/elves/elvish/pkg/buildinfo.Reproducible=true" ];

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i7RJiR1Mta2TrWBSUk0WM3InMV2cwbdlp3KHUdZgQ8I=";
  };

  vendorSha256 = "sha256-5tZwGrp/L9L+pf/yp8zlbb0voe60+if+NNf8ua2MujI=";

  doCheck = false;

  meta = with lib; {
    description = "A friendly and expressive command shell";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    homepage = "https://elv.sh/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra AndersonTorres ];
    platforms = with platforms; linux ++ darwin;
  };

  passthru = {
    shellPath = "/bin/elvish";
  };
}
