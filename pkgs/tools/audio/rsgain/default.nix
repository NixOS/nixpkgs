{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libebur128
, taglib
, ffmpeg
, inih
, fmt
, libz
}:

stdenv.mkDerivation rec {
  pname = "rsgain";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AiNjsrwTF6emcwXo2TPMbs8mLavGS7NsvytAppMGKfY=";
  };

  buildInputs = [ libebur128 taglib ffmpeg inih fmt libz ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A simple, but powerful ReplayGain 2.0 tagging utility ";
    changelog = "https://github.com/complexlogic/rsgain/releases/tag/v${version}";
    maintainers = [ maintainers.gaykitty ];
    license = licenses.bsd2;
  };
}
