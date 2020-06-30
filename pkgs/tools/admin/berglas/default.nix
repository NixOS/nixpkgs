{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "berglas";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gww2yldaci6gczd0fg0rn0z8wf3d4p1xax4aihas7zizhb40s3z";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}