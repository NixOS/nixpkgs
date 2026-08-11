{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "upload";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "fdintino";
    repo = "nginx-upload-module";
    tag = finalAttrs.version;
    hash = "sha256-8veZP516oC7TESO368ZsZreetbDt+1eTcamk7P1kWjU=";
  };

  meta = {
    description = "Handle file uploads using multipart/form-data encoding and resumable uploads";
    homepage = "https://github.com/fdintino/nginx-upload-module";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
