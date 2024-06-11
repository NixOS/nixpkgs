{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, file }:

stdenv.mkDerivation rec {
  pname = "exfatprogs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-v/SN2RAX+RjNReYkbXYy5Lm/NgIeDeLnAVx5cWo01tM=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook file ];

  meta = with lib; {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zane ];
    platforms = platforms.linux;
  };
}
