{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {

  name = "berglas-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "berglas";
    rev = "v0.2.1";
    sha256 = "1m34rxiynmgsris1avjn7am50b8sds77515zlnna9qvsrywbzljc";
  };

  modSha256 = "0lfcrsb4r5hxxd652cxff23fnbrphp3lgwp5anpaddzcjcd2qyj8";

  meta = with stdenv.lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = https://github.com/GoogleCloudPlatform/berglas;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
