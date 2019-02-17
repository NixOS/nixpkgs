{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "crex";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "octobanana";
    repo = "crex";
    rev = version;
    sha256 = "086rvwl494z48acgsq3yq11qh1nxm8kbf11adn16aszai4d4ipr3";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/usr/local/bin" "bin"
  '';

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Explore, test, and check regular expressions in the terminal";
    homepage = https://octobanana.com/software/crex;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
