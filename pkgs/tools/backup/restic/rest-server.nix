{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    sha256 = "1msa6mah76zfif5wp0129jjk2jlq5ff38p9p6d241mw45i1xjfy7";
  };

  vendorSha256 = "04w63sx7p0fm9xq0m7xab808az7lgw7i3p8basndszky8kgvxhmg";

  preCheck = ''
    substituteInPlace handlers_test.go --replace "TestJoin" "SkipTestJoin"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A high performance HTTP server that implements restic's REST backend API";
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
