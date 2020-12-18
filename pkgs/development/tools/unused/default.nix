{ rustPlatform, fetchFromGitHub, lib, stdenv
, pkgconfig
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "unused";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = "unused";
    rev = version;
    sha256 = "0ympdwqv9l66cn1cmg7g2d1rsq34a2bp5yv22ljr859hbk3w1jbq";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  cargoSha256 = "1scs4yjf70k54i94d520xkd1q4wbqfcs5048j7zhiphmkykx22br";

  meta = with lib; {
    homepage = "https://github.com/unused-code/unused/";
    license = licenses.mit;
    description = "A tool to identify potentially unused code";
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
  };
}
