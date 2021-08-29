{lib, stdenv, fetchgit, autoreconfHook, halibut}:
let
  date = "20200705";
  rev = "2a7d4a2";
in
stdenv.mkDerivation {
  pname = "agedu";
  version = "${date}.${rev}";

  # upstream provides tarballs but it seems they disappear after the next version is released
  src = fetchgit {
    url = "https://git.tartarus.org/simon/agedu.git";
    inherit rev;
    sha256 = "gRNscl/vhBoZaHFCs9JjDBHDRoEpILJLtiI4YV+K/b4=";
  };

  nativeBuildInputs = [autoreconfHook halibut];

  meta = with lib; {
    description = "A Unix utility for tracking down wasted disk space";
    longDescription = ''
       Most Unix file systems, in their default mode, helpfully record when a
       file was last accessed. So if you generated a large amount of data years
       ago, forgot to clean it up, and have never used it since, then it ought
       in principle to be possible to use those last-access time stamps to tell
       the difference between that and a large amount of data you're still
       using regularly.

       agedu uses this information to tell you which files waste disk space when
       you haven't used them since a long time.
    '';
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/agedu/";
    license = licenses.mit;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.unix;
  };
}
