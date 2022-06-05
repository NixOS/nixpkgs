{ lib, stdenv, fetchurl, cmake, halibut }:

stdenv.mkDerivation rec {
  pname = "xtruss";
  version = "20211025.c25bf48";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss/${pname}-${version}.tar.gz";
    sha256 = "sha256-ikuKHtXEn2UVLE62l7qD9qc9ZUk6jiAqj5ru36vgdHk=";
  };

  nativeBuildInputs = [ cmake halibut ];

  meta = with lib; {
    description = "easy-to-use X protocol tracing program";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/xtruss";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
