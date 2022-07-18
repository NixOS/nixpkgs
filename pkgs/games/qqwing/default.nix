{ lib, stdenv, fetchFromGitHub, perl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "qqwing";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "stephenostermiller";
    repo = "qqwing";
    rev = "v${version}";
    sha256 = "1qq0vi4ch4y3a5fb1ncr0yzkj3mbvdiwa3d51qpabq94sh0cz09i";
  };

  postPatch = ''
    for file in "src-first-comment.pl" "src_neaten.pl"; do
      substituteInPlace "build/$file" \
        --replace "#!/usr/bin/perl" "#!${perl}/bin/perl"
    done

    substituteInPlace "build/cpp_install.sh" \
      --replace "sudo " ""
  '';

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ perl libtool ];

  makeFlags = [ "prefix=$(out)" "tgz" ];

  meta = with lib; {
    homepage = "https://qqwing.com";
    description = "Sudoku generating and solving software";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
