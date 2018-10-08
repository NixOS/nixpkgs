{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "scdoc-${version}";
  version = "1.4.2";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/scdoc";
    rev = version;
    sha256 = "00a23kw8d36qik6h5kds13pzfnr58krlblfh9n2f0rldf0m9ldk1";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
    # It happens from time to time that the version wasn't updated:
    sed -iE 's/VERSION=[0-9]\.[0-9]\.[0-9]/VERSION=${version}/' Makefile
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = https://git.sr.ht/~sircmpwn/scdoc/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
