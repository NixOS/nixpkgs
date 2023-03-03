{ lib, stdenv, fetchFromGitLab, autoreconfHook, libsamplerate, SDL2, SDL2_mixer, readline }:

stdenv.mkDerivation rec {
  pname = "1oom";
  version = "1.0";

  src = fetchFromGitLab {
    owner = "KilgoreTroutMaskReplicant";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+HwSykSyAGHtITVOu4nIG87kWwVxGyFXb/NRSjhWlvs=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libsamplerate SDL2 SDL2_mixer readline ];

  outputs = [ "out" "doc" ];

  postInstall = ''
    install -d $doc/share/doc/${pname}
    install -t $doc/share/doc/${pname} \
      HACKING NEWS PHILOSOPHY README doc/*.txt
  '';

  meta = with lib; {
    homepage = "https://kilgoretroutmaskreplicant.gitlab.io/plain-html/";
    description = "Master of Orion (1993) game engine recreation";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
