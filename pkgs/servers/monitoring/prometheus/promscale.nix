{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-xkVT7Kn7mW23p8oGU4AsmB66lNd4QLnhEW7J66ldFHM=";
  };

  vendorSha256 = "sha256:1wfyawbdbabyp9nyhzfp632hg9rvwdyagsdqvvq6gv8bn5xfcjvh";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/timescale/promscale/pkg/version.Version=${version} -X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}" ];

  doCheck = false; # Requires access to a docker daemon

  meta = with stdenv.lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
