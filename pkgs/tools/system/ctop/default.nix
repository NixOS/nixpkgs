{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y72l65xgfqrgghzbm1zcy776l5m31z0gn6vfr689zyi3k3f4kh8";
  };

  modSha256 = "0wxv6yzlgki7047qszx9p9xpph95bg097jkgaa0b3wbpx8vg7qml";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.build=v${version}" ];

  meta = with stdenv.lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam ];
  };
}
