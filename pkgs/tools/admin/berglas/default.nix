{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {

  name = "berglas-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v0.2.0";
    sha256 = "1d75x0n1d1ry2xmy6h64qqc0dlnivipycv3p0aihyp3l810gpdbk";
  };

  modSha256 = "0fvgvrvdpdwjx51wmbf0rdwnr9l1l212qbvznvif3xsi5nnlkx6r";

  meta = with stdenv.lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = https://github.com/GoogleCloudPlatform/berglas;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
