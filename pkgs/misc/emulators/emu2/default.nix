{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "emu2";
  version = "unstable-2020-06-04";

  src = fetchFromGitHub {
    owner  = "dmsc";
    repo   = "emu2";
    rev    = "f9599d347aab07d9281400ec8b214aabd187fbcd";
    sha256 = "0d8fb3wp477kfi0p4mmr69lxsbgb4gl9pqmm68g9ixzrfch837v4";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/dmsc/emu2/";
    description = "A simple text-mode x86 + DOS emulator";
    platforms = platforms.linux;
    maintainers = with maintainers; [ dramaturg ];
    license = licenses.gpl2;
  };
}
