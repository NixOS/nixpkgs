{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "fancyindex";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "ngx-fancyindex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-70bEZ5EVM3jjY5b9azXYBvJnFDoqgGXu0F7JcWkhWVk=";
  };

  meta = {
    description = "Fancy indexes module";
    homepage = "https://github.com/aperezdc/ngx-fancyindex";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aneeshusa ];
  };
})
