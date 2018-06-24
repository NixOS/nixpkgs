{stdenv, fetchgit, autoreconfHook, halibut}:
let
  date = "20180522";
  rev = "5b12791";
in
stdenv.mkDerivation {
  name = "agedu-${date}.${rev}";
  # upstream provides tarballs but it seems they disappear after the next version is released
  src = fetchgit {
    url = https://git.tartarus.org/simon/agedu.git;
    inherit rev;
    sha256 = "1zyxif0i3yil4xm8y9aqk6wsdwi7b3jg682lv6ds6a6bl047fz1q";
  };

  nativeBuildInputs = [autoreconfHook halibut];

  meta = with stdenv.lib; {
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
    homepage = https://www.chiark.greenend.org.uk/~sgtatham/agedu/;
    license = licenses.mit;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.linux;
  };
}
