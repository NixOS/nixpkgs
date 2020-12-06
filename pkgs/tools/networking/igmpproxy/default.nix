{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "igmpproxy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "igmpproxy";
    rev = version;
    sha256 = "13zn4q24drbhpqmcmqh1jg7ind5iqn11wj3xvczlc8w35vyqssyf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A daemon that routes multicast using IGMP forwarding";
    homepage = "https://github.com/pali/igmpproxy/";
    changelog = "https://github.com/pali/igmpproxy/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sdier ];
    # The maintainer is using this on linux, but if you test it on other platforms
    # please add them here!
    platforms = platforms.linux;
  };
}
