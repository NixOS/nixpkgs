{ stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.20.1";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "rvoicilas";
    rev = version;
    sha256 = "14dci1i4mhsd5sa33k8h3ayphk19kizynh5ql9ryibdpmcanfiyq";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rvoicilas/inotify-tools/wiki;
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber pSub ];
    platforms = platforms.linux;
  };
}
