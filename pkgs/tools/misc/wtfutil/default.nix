{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wtfutil";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = "wtf";
    rev = "v${version}";
    sha256 = "2feaem2ABxquEmNYJgoB2HqCAwDfyE5ch9IvxENu/gc=";
  };

  vendorSha256 = "NO2pzKM5vX+u3SsQduDr4P2qxmaVZnqFNiCoqf3Glso=";

  meta = with stdenv.lib; {
    description = "WTF is the personal information dashboard for your terminal.";
    homepage = "https://github.com/wtfutil/wtf";
    license = licenses.mit;
    maintainers = with maintainers; [ anhdle14 ];
  };
}
