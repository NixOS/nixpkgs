{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "0.16.3";

  excludedPackages = [ "website" ];

  ldflags = [ "-s" "-w" "-X github.com/elves/elvish/pkg/buildinfo.Version==${version}" "-X github.com/elves/elvish/pkg/buildinfo.Reproducible=true" ];

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "v${version}";
    sha256 = "1na2fswqp4rbgvlagz9nj3cmlxavlhi2gj6k6jpjq05mcbkxr3bd";
  };

  vendorSha256 = "06rx09vs08d9arim53al73z22hb40xj2101kbvafz6wbyp6pqws1";

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
  };

  passthru = {
    shellPath = "/bin/elvish";
  };
}
