{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.2.7";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p2gznrsvv82zxbajqir8y2ap1ribbgagqg1bzhv3i81p2byhjh7";
  };

  patches = [
    ./fix-configure-path.patch

    # Fix parallel make depends:
    # - https://github.com/Orc/discount/commit/e42188e6c4c30d9de668cf98d98dd0c13ecce7cf.patch
    # - https://github.com/Orc/discount/pull/245
    ./parallel-make.patch
  ];
  configureScript = "./configure.sh";

  configureFlags = [
    "--enable-all-features"
    "--pkg-config"
    "--shared"
    "--with-fenced-code"
    # Use deterministic mangling
    "--debian-glitch"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libmarkdown.dylib $out/lib/libmarkdown.dylib
  '';

  meta = with lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ];
    platforms = platforms.unix;
  };
}
