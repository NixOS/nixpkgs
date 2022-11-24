{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule {
  pname = "d2";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    rev = "v0.0.13";
    sha256 = "sha256-2abGQmgwqxWFk7NScdgfEjRYZF2rw8kxTKRwcl2LRg0=";
  };

  vendorHash = "sha256-/BEl4UqOL4Ux7I2eubNH2YGGl4DxntpI5WN9ggvYu80=";

  nativeBuildInputs = [ git ];

  makeFlags = [ "PREFIX=$(out)" ];

  # This environment variable is required to pass the tests
  TESTDATA_ACCEPT = 1;

  meta = with lib; {
    description = "Modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com/";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pleshevskiy ];
  };
}
