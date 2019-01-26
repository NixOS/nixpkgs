{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "ssdeep-${version}";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "ssdeep-project";
    repo = "ssdeep";
    rev = "release-${version}";
    sha256 = "1yx6yjkggshw5yl89m4kvyzarjdg2l3hs0bbjbrfzwp1lkfd8i0c";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "A program for calculating fuzzy hashes";
    homepage    = "http://www.ssdeep.sf.net";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
