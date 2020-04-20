{ stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "advancecomp";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "advancecomp";
    rev = "v${version}";
    sha256 = "1pd6czamamrd0ppk5a3a65hcgdlqwja98aandhqiajhnibwldv8x";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  patches = [
    (fetchpatch {
      name = "CVE-2019-9210.patch";
      url = "https://github.com/amadvance/advancecomp/commit/fcf71a89265c78fc26243574dda3a872574a5c02.patch";
      sha256 = "0cdv9g87c1y8zwhqkd9ba2zjw4slcvg7yzcqv43idvnwb5fl29n7";
      excludes = [ "doc/history.d" ];
    })
  ];

  # autover.sh relies on 'git describe', which obviously doesn't work as we're not cloning
  # the full git repo. so we have to put the version number in `.version`, otherwise
  # the binaries get built reporting "none" as their version number.
  postPatch = ''
    echo "${version}" >.version
  '';

  meta = with stdenv.lib; {
    description = ''A set of tools to optimize deflate-compressed files'';
    license = licenses.gpl3 ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "https://github.com/amadvance/advancecomp";

  };
}
