{
  fetchFromGitHub,
  lib,
  libbsd,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "ipscrub";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "masonicboom";
    repo = "ipscrub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/4f6dwER39md7aqq1CdBNlh8mi/e1wnF91UvjlgJnWE=";
  };

  sourceRoot = "${finalAttrs.src.name}/ipscrub";

  buildInputs = [ libbsd ];

  meta = {
    description = "IP address anonymizer";
    homepage = "https://github.com/masonicboom/ipscrub";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
