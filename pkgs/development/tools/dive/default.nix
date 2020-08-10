{ stdenv, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, gpgme, lvm2 }:

buildGoModule rec {
  pname = "dive";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v69xbkjmyzm5g4wi9amjk65fs4qgxkqc0dvq55vqjigzrranp22";
  };

  vendorSha256 = "0219q9zjc0i6fbdngqh0wjpmq8wj5bjiz5dls0c1aam0lh4vwkhc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = "https://github.com/wagoodman/dive";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
