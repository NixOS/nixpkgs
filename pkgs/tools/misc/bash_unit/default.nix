{ fetchFromGitHub
, lib
, stdenv
, coreutils
, gnugrep
, gnused
}:

stdenv.mkDerivation rec {
  pname = "bash_unit";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pgrange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-c1C+uBo5PSH07VjulCxkmvfj7UYm6emdDAaN00uvAcg=";
  };

  patchPhase = ''
    substituteInPlace bash_unit \
      --replace '"$(which cat)"' "${lib.getExe' coreutils "cat"}" \
      --replace '"$(which rm)"' "${lib.getExe' coreutils "rm"}" \
      --replace '"$(which shuf)"' "${lib.getExe' coreutils "shuf"}" \
      --replace '"$(which sed)"' "${lib.getExe gnused}" \
      --replace '"$(which grep)"' "${lib.getExe gnugrep}"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bash_unit $out/bin/
  '';

  meta = with lib; {
    description = "Bash unit testing enterprise edition framework for professionals";
    maintainers = with maintainers; [ pamplemousse ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
  };
}
