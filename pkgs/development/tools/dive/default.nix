{ stdenv, buildGoModule, fetchFromGitHub, pkg-config, btrfs-progs, gpgme, lvm2 }:

buildGoModule rec {
  pname = "dive";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dqaqzmb74kf6q70wxfbsrbbfmxl82rj7r5kpsg5znm99filk3ny";
  };

  modSha256 = "1y8mqxlzbizra2m9aayp6w07s39gddvm5igdaw9kwxwjwvd1dbfc";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  meta = with stdenv.lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = https://github.com/wagoodman/dive;
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie ];
  };
}
