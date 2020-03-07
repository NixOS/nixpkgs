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

  modSha256 = "1y8mqxlzbizra2m9aayp6w07s39gddvm5igdaw9kwxwjwvd1dbfc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
